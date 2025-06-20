import UIKit
@testable import CurrencyConverter

final class MockExchangeRateCalculator: ExchangeRateCalculator {
    var exchangeRate: Double = 1.0
    var updateRatesCalled = false
    
    func updateRates(_ rates: [ExchangeRate]) {
        updateRatesCalled = true
    }
    
    func getExchangeRate(from: Currency, to: Currency) -> Double {
        return exchangeRate
    }
}
