import Foundation

struct ConversionRecord: Identifiable, Codable, Hashable {
    let id: UUID
    let fromCurrency: Currency
    let toCurrency: Currency
    let fromAmount: Double
    let toAmount: Double
    let rate: Double
    let timestamp: Date
    var isFavorite: Bool
    var tags: [String]
    var note: String?
    
    init(
        fromCurrency: Currency,
        toCurrency: Currency,
        fromAmount: Double,
        toAmount: Double,
        rate: Double,
        isFavorite: Bool = false,
        tags: [String] = [],
        note: String? = nil
    ) {
        self.id = UUID()
        self.fromCurrency = fromCurrency
        self.toCurrency = toCurrency
        self.fromAmount = fromAmount
        self.toAmount = toAmount
        self.rate = rate
        self.timestamp = Date()
        self.isFavorite = isFavorite
        self.tags = tags
        self.note = note
    }
}

extension ConversionRecord {
    
    var currencyPair: String {
        "\(fromCurrency.rawValue)/\(toCurrency.rawValue)"
    }
    
    var formattedFromAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter.string(from: NSNumber(value: fromAmount)) ?? "0"
    }
    
    var formattedToAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter.string(from: NSNumber(value: toAmount)) ?? "0"
    }
    
    var formattedRate: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 6
        formatter.minimumFractionDigits = 2
        return formatter.string(from: NSNumber(value: rate)) ?? "0"
    }
    
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }
    
    var isToday: Bool {
        Calendar.current.isDateInToday(timestamp)
    }
    
    var isThisWeek: Bool {
        let calendar = Calendar.current
        let weekOfYear = calendar.component(.weekOfYear, from: Date())
        let recordWeekOfYear = calendar.component(.weekOfYear, from: timestamp)
        let year = calendar.component(.year, from: Date())
        let recordYear = calendar.component(.year, from: timestamp)
        
        return weekOfYear == recordWeekOfYear && year == recordYear
    }
    
    var isThisMonth: Bool {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: Date())
        let recordMonth = calendar.component(.month, from: timestamp)
        let year = calendar.component(.year, from: Date())
        let recordYear = calendar.component(.year, from: timestamp)
        
        return month == recordMonth && year == recordYear
    }
}
