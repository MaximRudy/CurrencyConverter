import UIKit
@testable import CurrencyConverter

final class MockCacheService: CacheServiceProtocol {
    var savedCurrencyPair: CurrencyPair?
    var shouldUpdateRatesResult = false
    var lastUpdateTime: Date?
    var exchangeRates: [ExchangeRate] = []
    
    var saveExchangeRatesCalled = false
    var addConversionRecordCalled = false
    
    func loadCurrencyPair() -> CurrencyPair? {
        return savedCurrencyPair
    }
    
    func saveCurrencyPair(_ pair: CurrencyPair) {
        savedCurrencyPair = pair
    }
    
    var shouldUpdateRates: Bool {
        return shouldUpdateRatesResult
    }
    
    func loadExchangeRates() -> [ExchangeRate] {
        return exchangeRates
    }
    
    func saveExchangeRates(_ rates: [ExchangeRate]) {
        saveExchangeRatesCalled = true
        exchangeRates = rates
    }
    
    func addConversionRecord(_ record: ConversionRecord) {
        addConversionRecordCalled = true
    }
    
    func saveConversionHistory(_ history: [CurrencyConverter.ConversionRecord]) {}
    
    func loadConversionHistory() -> [CurrencyConverter.ConversionRecord] {
        return []
    }
    
}
