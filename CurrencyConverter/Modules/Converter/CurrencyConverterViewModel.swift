import Foundation
import Combine

@MainActor
final class CurrencyConverterViewModel: ObservableObject {
    @Published var fromCurrency: Currency = .usd
    @Published var toCurrency: Currency = .rub
    @Published var fromAmount: String = ""
    @Published var toAmount: String = "0.00"
    @Published var exchangeRate: Double = 0.0
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var lastUpdateTime: Date?
    @Published var rateHistory: [RateHistoryPoint] = []
    @Published var favoriteConversions: [FavoriteConversion] = []
    
    private let apiService: CurrencyAPIServiceProtocol
    private let cacheService: CacheServiceProtocol
    private let favoritesService: FavoritesServiceProtocol
    private let rateCalculator: ExchangeRateCalculator
    private let inputValidator: InputValidator
    
    private var cancellables = Set<AnyCancellable>()
    private var refreshTimer: Timer?
    private let refreshInterval: TimeInterval
    
    var canSaveConversion: Bool {
        inputValidator.isValidConversion(
            fromAmount: fromAmount,
            toAmount: toAmount,
            isLoading: isLoading
        )
    }
    
    var formattedLastUpdateTime: String? {
        guard let lastUpdateTime = lastUpdateTime else { return nil }
        return DateFormatter.shortTimeFormatter.string(from: lastUpdateTime)
    }
    
    init(
        apiService: CurrencyAPIServiceProtocol = CurrencyAPIService(),
        cacheService: CacheServiceProtocol = CacheService(),
        favoritesService: FavoritesServiceProtocol = FavoritesService(),
        rateCalculator: ExchangeRateCalculator = DefaultExchangeRateCalculator(),
        inputValidator: InputValidator = DefaultInputValidator(),
        refreshInterval: TimeInterval = 300
    ) {
        self.apiService = apiService
        self.cacheService = cacheService
        self.favoritesService = favoritesService
        self.rateCalculator = rateCalculator
        self.inputValidator = inputValidator
        self.refreshInterval = refreshInterval
        
        setupBindings()
        loadInitialData()
        setupAutoRefresh()
        
        Task {
            await fetchExchangeRatesIfNeeded()
        }
    }
    
    deinit {
        refreshTimer?.invalidate()
    }
}

// MARK: - Public Methods
extension CurrencyConverterViewModel {
    func swapCurrencies() {
        let tempCurrency = fromCurrency
        _ = fromAmount
        
        fromCurrency = toCurrency
        toCurrency = tempCurrency
        
        if inputValidator.isValidAmount(toAmount) {
            fromAmount = toAmount
        }
        
        convertCurrency()
    }
    
    func refreshRates() async {
        await fetchExchangeRates(forceUpdate: true)
    }
    
    func saveConversion() {
        guard canSaveConversion else { return }
        
        do {
            let record = try createConversionRecord()
            cacheService.addConversionRecord(record)
            addToFavorites()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func addToFavorites() {
        let favorite = FavoriteConversion(
            fromCurrency: fromCurrency,
            toCurrency: toCurrency
        )
        
        do {
            try favoritesService.addFavorite(favorite)
            loadFavoriteConversions()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func removeFromFavorites(_ favorite: FavoriteConversion) {
        do {
            try favoritesService.removeFavorite(favorite)
            loadFavoriteConversions()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func clearError() {
        errorMessage = nil
    }
    
    func selectFavoriteConversion(_ favorite: FavoriteConversion) {
        fromCurrency = favorite.fromCurrency
        toCurrency = favorite.toCurrency
    }
}

// MARK: - Private Methods
private extension CurrencyConverterViewModel {
    func setupBindings() {
        $fromAmount
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.convertCurrency()
            }
            .store(in: &cancellables)
        
        Publishers.CombineLatest($fromCurrency, $toCurrency)
            .sink { [weak self] from, to in
                self?.handleCurrencyPairChange(from: from, to: to)
            }
            .store(in: &cancellables)
    }
    
    func setupAutoRefresh() {
        refreshTimer = Timer.scheduledTimer(withTimeInterval: refreshInterval, repeats: true) { [weak self] _ in
            Task {
                await self?.fetchExchangeRatesIfNeeded()
            }
        }
    }
    
    func loadInitialData() {
        loadSavedCurrencyPair()
        loadCachedRates()
        loadFavoriteConversions()
    }
    
    func loadSavedCurrencyPair() {
        if let savedPair = cacheService.loadCurrencyPair() {
            fromCurrency = savedPair.from
            toCurrency = savedPair.to
        }
    }
    
    func loadCachedRates() {
        let cachedRates = cacheService.loadExchangeRates()
        rateCalculator.updateRates(cachedRates)
        lastUpdateTime = cacheService.lastUpdateTime
    }
    
    func loadFavoriteConversions() {
        favoriteConversions = favoritesService.loadFavorites()
    }
    
    func handleCurrencyPairChange(from: Currency, to: Currency) {
        saveCurrencyPair(CurrencyPair(from: from, to: to))
        Task {
            await fetchExchangeRatesIfNeeded()
        }
    }
    
    func saveCurrencyPair(_ pair: CurrencyPair) {
        cacheService.saveCurrencyPair(pair)
    }
    
    func fetchExchangeRatesIfNeeded() async {
        guard cacheService.shouldUpdateRates else {
            convertCurrency()
            return
        }
        
        await fetchExchangeRates(forceUpdate: false)
    }
    
    func fetchExchangeRates(forceUpdate: Bool) async {
        guard forceUpdate || cacheService.shouldUpdateRates else {
            convertCurrency()
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let rates = try await apiService.fetchExchangeRates(
                baseCurrency: fromCurrency,
                targetCurrencies: Currency.allCases.filter { $0 != fromCurrency }
            )
            
            handleSuccessfulRatesFetch(rates)
        } catch {
            handleRatesFetchError(error)
        }
        
        isLoading = false
    }
    
    func handleSuccessfulRatesFetch(_ rates: [ExchangeRate]) {
        cacheService.saveExchangeRates(rates)
        rateCalculator.updateRates(rates)
        updateRateHistory(rates)
        lastUpdateTime = Date()
        convertCurrency()
    }
    
    func handleRatesFetchError(_ error: Error) {
        errorMessage = error.localizedDescription
        convertCurrency()
    }
    
    func updateRateHistory(_ rates: [ExchangeRate]) {
        guard let currentRate = rates.first(where: {
            $0.fromCurrency == fromCurrency && $0.toCurrency == toCurrency
        }) else { return }
        
        let historyPoint = RateHistoryPoint(
            rate: currentRate.rate,
            timestamp: Date()
        )
        
        rateHistory.append(historyPoint)
        
        if rateHistory.count > 100 {
            rateHistory.removeFirst()
        }
    }
    
    func convertCurrency() {
        guard let amount = inputValidator.parseAmount(fromAmount), amount > 0 else {
            toAmount = "0.00"
            exchangeRate = 0.0
            return
        }
        
        let rate = rateCalculator.getExchangeRate(from: fromCurrency, to: toCurrency)
        exchangeRate = rate
        let convertedAmount = amount * rate
        toAmount = String(format: "%.2f", convertedAmount)
    }
    
    func createConversionRecord() throws -> ConversionRecord {
        guard let fromAmountDouble = inputValidator.parseAmount(fromAmount),
              let toAmountDouble = inputValidator.parseAmount(toAmount),
              fromAmountDouble > 0,
              toAmountDouble > 0 else {
            throw ConversionError.invalidAmount
        }
        
        return ConversionRecord(
            fromCurrency: fromCurrency,
            toCurrency: toCurrency,
            fromAmount: fromAmountDouble,
            toAmount: toAmountDouble,
            rate: exchangeRate
        )
    }
}
