import Foundation
import Combine

protocol CurrencyAPIServiceProtocol {
    func fetchExchangeRates(baseCurrency: Currency, targetCurrencies: [Currency]) async throws -> [ExchangeRate]
}

class CurrencyAPIService: CurrencyAPIServiceProtocol {
    private let baseURL = "https://api.freecurrencyapi.com/v1/latest"
    private let apiKey = "fca_live_REJ1q4Mrb1gkquTeaRvfmZhiSp26LWK5HlE8FcCr"
    
    func fetchExchangeRates(baseCurrency: Currency, targetCurrencies: [Currency]) async throws -> [ExchangeRate] {
        let currencies = targetCurrencies.map { $0.rawValue }.joined(separator: ",")
        
        guard var urlComponents = URLComponents(string: baseURL) else {
            throw CurrencyError.invalidURL
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "apikey", value: apiKey),
            URLQueryItem(name: "base_currency", value: baseCurrency.rawValue),
            URLQueryItem(name: "currencies", value: currencies)
        ]
        
        guard let url = urlComponents.url else {
            throw CurrencyError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw CurrencyError.networkError
        }
        
        let exchangeResponse = try JSONDecoder().decode(ExchangeRateResponse.self, from: data)
        return exchangeResponse.data.compactMap { (currencyCode, rate) in
            guard let currency = Currency(rawValue: currencyCode) else { return nil }
            return ExchangeRate(
                fromCurrency: baseCurrency,
                toCurrency: currency,
                rate: rate,
                timestamp: Date()
            )
        }
    }
}
