import SwiftUI
import Combine

protocol HistoryViewModelProtocol: ObservableObject {
    var conversionHistory: [ConversionRecord] { get }
    var filteredHistory: [ConversionRecord] { get }
    var searchText: String { get set }
    var thisMonthCount: Int { get }
    var favoritePairsCount: Int { get }
    
    func loadHistory()
    func addRecord(_ record: ConversionRecord)
    func deleteRecord(_ record: ConversionRecord)
    func applyFilters()
    func resetFilters()
    func clearAllHistory()
}

class HistoryViewModel: HistoryViewModelProtocol {
    
    @Published var conversionHistory: [ConversionRecord] = []
    @Published var filteredHistory: [ConversionRecord] = []
    @Published var searchText = "" {
        didSet { applyFilters() }
    }
    
    @Published var filterStartDate = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
    @Published var filterEndDate = Date()
    @Published var isDateFilterEnabled = false {
        didSet { applyFilters() }
    }
    
    @Published var filterFromCurrency: Currency? = nil {
        didSet { applyFilters() }
    }
    @Published var filterToCurrency: Currency? = nil {
        didSet { applyFilters() }
    }
    
    @Published var filterMinAmount: Double = 0 {
        didSet {
            if isAmountFilterEnabled { applyFilters() }
        }
    }
    @Published var filterMaxAmount: Double = 10000 {
        didSet {
            if isAmountFilterEnabled { applyFilters() }
        }
    }
    @Published var isAmountFilterEnabled = false {
        didSet { applyFilters() }
    }
    
    @Published var sortOption: SortOption = .dateNewest {
        didSet { applyFilters() }
    }
    
    @Published var favoriteRecords: Set<UUID> = []
    
    private var cancellables = Set<AnyCancellable>()
    private let storageKey = "conversionHistory"
    private let favoritesKey = "favoriteConversions"
    private let userDefaults: UserDefaults
    private let hapticFeedback: HapticFeedbackProtocol
    
    var thisMonthCount: Int {
        let calendar = Calendar.current
        let now = Date()
        guard let startOfMonth = calendar.dateInterval(of: .month, for: now)?.start else {
            return 0
        }
        
        return conversionHistory.filter { $0.timestamp >= startOfMonth }.count
    }
    
    var favoritePairsCount: Int {
        let pairs = Set(conversionHistory.map {
            "\($0.fromCurrency.rawValue)-\($0.toCurrency.rawValue)"
        })
        return pairs.count
    }
    
    init(userDefaults: UserDefaults = .standard,
         hapticFeedback: HapticFeedbackProtocol = HapticFeedback.shared) {
        self.userDefaults = userDefaults
        self.hapticFeedback = hapticFeedback
        
        loadHistory()
        loadFavorites()
        setupDateFilterObserver()
    }
}

// MARK: - Public Methods
extension HistoryViewModel {
    func loadHistory() {
        guard let data = userDefaults.data(forKey: storageKey) else {
            applyFilters()
            return
        }
        
        do {
            conversionHistory = try JSONDecoder().decode([ConversionRecord].self, from: data)
            applyFilters()
        } catch {
            print("Failed to load history: \(error)")
            conversionHistory = []
            applyFilters()
        }
    }
    
    func saveHistory() {
        do {
            let data = try JSONEncoder().encode(conversionHistory)
            userDefaults.set(data, forKey: storageKey)
        } catch {
            print("Failed to save history: \(error)")
        }
    }
    
    func addRecord(_ record: ConversionRecord) {
        conversionHistory.insert(record, at: 0)
        saveHistory()
        applyFilters()
    }
    
    func deleteRecord(_ record: ConversionRecord) {
        conversionHistory.removeAll { $0.id == record.id }
        favoriteRecords.remove(record.id)
        saveHistory()
        saveFavorites()
        applyFilters()
        hapticFeedback.notification(.success)
    }
    
    func toggleFavorite(_ record: ConversionRecord) {
        if favoriteRecords.contains(record.id) {
            favoriteRecords.remove(record.id)
        } else {
            favoriteRecords.insert(record.id)
        }
        saveFavorites()
        hapticFeedback.impact(.light)
    }
    
    func isFavorite(_ record: ConversionRecord) -> Bool {
        favoriteRecords.contains(record.id)
    }
    
    func applyFilters() {
        var filtered = conversionHistory
        
        if !searchText.isEmpty {
            filtered = filtered.filter { record in
                record.fromCurrency.rawValue.localizedCaseInsensitiveContains(searchText) ||
                record.toCurrency.rawValue.localizedCaseInsensitiveContains(searchText) ||
                record.fromCurrency.name.localizedCaseInsensitiveContains(searchText) ||
                record.toCurrency.name.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if isDateFilterEnabled {
            filtered = filtered.filter { record in
                record.timestamp >= filterStartDate && record.timestamp <= filterEndDate
            }
        }
        
        if let fromCurrency = filterFromCurrency {
            filtered = filtered.filter { $0.fromCurrency == fromCurrency }
        }
        
        if let toCurrency = filterToCurrency {
            filtered = filtered.filter { $0.toCurrency == toCurrency }
        }
        
        if isAmountFilterEnabled {
            filtered = filtered.filter { record in
                record.fromAmount >= filterMinAmount && record.fromAmount <= filterMaxAmount
            }
        }
        
        filtered = applySorting(to: filtered)
        
        filteredHistory = filtered
    }
    
    func resetFilters() {
        searchText = ""
        isDateFilterEnabled = false
        filterFromCurrency = nil
        filterToCurrency = nil
        isAmountFilterEnabled = false
        filterMinAmount = 0
        filterMaxAmount = 10000
        sortOption = .dateNewest
        
        applyFilters()
    }
    
    func clearAllHistory() {
        conversionHistory.removeAll()
        filteredHistory.removeAll()
        favoriteRecords.removeAll()
        saveHistory()
        saveFavorites()
        hapticFeedback.notification(.warning)
    }
}

// MARK: - Private Methods
extension HistoryViewModel {
    private func setupDateFilterObserver() {
        Publishers.CombineLatest($filterStartDate, $filterEndDate)
            .sink { [weak self] _, _ in
                if self?.isDateFilterEnabled == true {
                    self?.applyFilters()
                }
            }
            .store(in: &cancellables)
    }
    
    private func applySorting(to records: [ConversionRecord]) -> [ConversionRecord] {
        switch sortOption {
        case .dateNewest:
            return records.sorted { $0.timestamp > $1.timestamp }
        case .dateOldest:
            return records.sorted { $0.timestamp < $1.timestamp }
        case .amountHighest:
            return records.sorted { $0.fromAmount > $1.fromAmount }
        case .amountLowest:
            return records.sorted { $0.fromAmount < $1.fromAmount }
        case .currencyPair:
            return records.sorted {
                let pair1 = "\($0.fromCurrency.rawValue)-\($0.toCurrency.rawValue)"
                let pair2 = "\($1.fromCurrency.rawValue)-\($1.toCurrency.rawValue)"
                return pair1 < pair2
            }
        }
    }
    
    private func loadFavorites() {
        if let data = userDefaults.data(forKey: favoritesKey),
           let favorites = try? JSONDecoder().decode(Set<UUID>.self, from: data) {
            favoriteRecords = favorites
        }
    }
    
    private func saveFavorites() {
        if let data = try? JSONEncoder().encode(favoriteRecords) {
            userDefaults.set(data, forKey: favoritesKey)
        }
    }
}
