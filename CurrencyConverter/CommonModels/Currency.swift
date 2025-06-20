import Foundation

enum Currency: String, CaseIterable, Codable {
    case rub = "RUB"
    case usd = "USD"
    case eur = "EUR"
    case gbp = "GBP"
    case chf = "CHF"
    case cny = "CNY"
    
    var id: String { rawValue }

    var name: String {
        switch self {
        case .rub: return "Russian Ruble"
        case .usd: return "US Dollar"
        case .eur: return "Euro"
        case .gbp: return "British Pound"
        case .chf: return "Swiss Franc"
        case .cny: return "Chinese Yuan"
        }
    }
    
    var flag: String {
        switch self {
        case .usd: return "🇺🇸"
        case .eur: return "🇪🇺"
        case .rub: return "🇷🇺"
        case .gbp: return "🇬🇧"
        case .cny: return "🇨🇳"
        case .chf: return "🇨🇭"
        }
    }
    
    var symbol: String {
        switch self {
        case .rub: return "₽"
        case .usd: return "$"
        case .eur: return "€"
        case .gbp: return "£"
        case .chf: return "CHF"
        case .cny: return "¥"
        }
    }
}
