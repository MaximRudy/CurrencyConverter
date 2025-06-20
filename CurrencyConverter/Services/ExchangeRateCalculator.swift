import Foundation

protocol ExchangeRateCalculator {
    func updateRates(_ rates: [ExchangeRate])
    func getExchangeRate(from: Currency, to: Currency) -> Double
}

final class DefaultExchangeRateCalculator: ExchangeRateCalculator {
    private var exchangeRates: [String: Double] = [:]
    
    func updateRates(_ rates: [ExchangeRate]) {
        exchangeRates.removeAll()
        for rate in rates {
            let key = "\(rate.fromCurrency.rawValue)_\(rate.toCurrency.rawValue)"
            exchangeRates[key] = rate.rate
        }
    }
    
    func getExchangeRate(from: Currency, to: Currency) -> Double {
        if from == to { return 1.0 }
        
        let directKey = "\(from.rawValue)_\(to.rawValue)"
        if let rate = exchangeRates[directKey] {
            return rate
        }
        
        let reverseKey = "\(to.rawValue)_\(from.rawValue)"
        if let reverseRate = exchangeRates[reverseKey], reverseRate > 0 {
            return 1.0 / reverseRate
        }
        
        if from != .usd && to != .usd {
            let fromUSDKey = "USD_\(from.rawValue)"
            let toUSDKey = "USD_\(to.rawValue)"
            
            if let fromUSDRate = exchangeRates[fromUSDKey],
               let toUSDRate = exchangeRates[toUSDKey],
               fromUSDRate > 0 {
                return toUSDRate / fromUSDRate
            }
        }
        
        return 0.0
    }
}
