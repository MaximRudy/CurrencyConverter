import Foundation
import Combine

protocol CacheServiceProtocol {
    func saveExchangeRates(_ rates: [ExchangeRate])
    func loadExchangeRates() -> [ExchangeRate]
    func saveCurrencyPair(_ pair: CurrencyPair)
    func loadCurrencyPair() -> CurrencyPair?
    func saveConversionHistory(_ history: [ConversionRecord])
    func loadConversionHistory() -> [ConversionRecord]
    func addConversionRecord(_ record: ConversionRecord)

    var shouldUpdateRates: Bool { get }
    var lastUpdateTime: Date? { get }
}

class CacheService: CacheServiceProtocol {
    private let userDefaults = UserDefaults.standard
    
    private enum Keys {
        static let exchangeRates = "exchangeRates"
        static let currencyPair = "currencyPair"
        static let conversionHistory = "conversionHistory"
        static let lastUpdateTime = "lastUpdateTime"
    }
    
    func saveExchangeRates(_ rates: [ExchangeRate]) {
        if let encoded = try? JSONEncoder().encode(rates) {
            userDefaults.set(encoded, forKey: Keys.exchangeRates)
            userDefaults.set(Date(), forKey: Keys.lastUpdateTime)
        }
    }
    
    func loadExchangeRates() -> [ExchangeRate] {
        guard let data = userDefaults.data(forKey: Keys.exchangeRates),
              let rates = try? JSONDecoder().decode([ExchangeRate].self, from: data) else {
            return []
        }
        return rates
    }
    
    func saveCurrencyPair(_ pair: CurrencyPair) {
        if let encoded = try? JSONEncoder().encode(pair) {
            userDefaults.set(encoded, forKey: Keys.currencyPair)
        }
    }
    
    func loadCurrencyPair() -> CurrencyPair? {
        guard let data = userDefaults.data(forKey: Keys.currencyPair),
              let pair = try? JSONDecoder().decode(CurrencyPair.self, from: data) else {
            return nil
        }
        return pair
    }
    
    func saveConversionHistory(_ history: [ConversionRecord]) {
        if let encoded = try? JSONEncoder().encode(history) {
            userDefaults.set(encoded, forKey: Keys.conversionHistory)
        }
    }
    
    func loadConversionHistory() -> [ConversionRecord] {
        guard let data = userDefaults.data(forKey: Keys.conversionHistory),
              let history = try? JSONDecoder().decode([ConversionRecord].self, from: data) else {
            return []
        }
        return history
    }
    
    func addConversionRecord(_ record: ConversionRecord) {
        var history = loadConversionHistory()
        history.insert(record, at: 0)
        
        if history.count > 1000 {
            history = Array(history.prefix(1000))
        }
        
        saveConversionHistory(history)
    }
    
    var lastUpdateTime: Date? {
        return userDefaults.object(forKey: Keys.lastUpdateTime) as? Date
    }
    
    var shouldUpdateRates: Bool {
        guard let lastUpdate = lastUpdateTime else { return true }
        return Date().timeIntervalSince(lastUpdate) > 300
    }
}
