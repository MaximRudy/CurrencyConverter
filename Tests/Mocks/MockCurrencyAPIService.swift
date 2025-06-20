import Foundation
@testable import CurrencyConverter

final class MockCurrencyAPIService: CurrencyAPIServiceProtocol {
    var exchangeRatesResult: Result<[ExchangeRate], Error> = .success([])
    var fetchExchangeRatesCalled = false
    
    func fetchExchangeRates(
        baseCurrency: Currency,
        targetCurrencies: [Currency]
    ) async throws -> [ExchangeRate] {
        fetchExchangeRatesCalled = true
        return try exchangeRatesResult.get()
    }
}

enum APIError: Error {
    case networkError
}
