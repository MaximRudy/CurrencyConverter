import UIKit
@testable import CurrencyConverter

final class MockInputValidator: InputValidator {
    var isValidAmountResult = true
    var parseAmountResult: Double? = 100.0
    var isValidConversionResult = true
    
    func isValidAmount(_ amount: String) -> Bool {
        return isValidAmountResult
    }
    
    func parseAmount(_ amount: String) -> Double? {
        return parseAmountResult
    }
    
    func isValidConversion(fromAmount: String, toAmount: String, isLoading: Bool) -> Bool {
        return isValidConversionResult
    }
}
