import Foundation

struct ExchangeRateResponse: Codable {
    let data: [String: Double]
}

struct ExchangeRate: Codable, Identifiable {
    let id = UUID()
    let fromCurrency: Currency
    let toCurrency: Currency
    let rate: Double
    let timestamp: Date
    
    private enum CodingKeys: String, CodingKey {
        case fromCurrency, toCurrency, rate, timestamp
    }
}
