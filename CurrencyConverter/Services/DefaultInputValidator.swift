import Foundation

protocol InputValidator {
    func isValidAmount(_ amount: String) -> Bool
    func parseAmount(_ amount: String) -> Double?
    func isValidConversion(fromAmount: String, toAmount: String, isLoading: Bool) -> Bool
}

final class DefaultInputValidator: InputValidator {
    func isValidAmount(_ amount: String) -> Bool {
        guard !amount.isEmpty, amount != "0.00" else { return false }
        return parseAmount(amount) != nil
    }
    
    func parseAmount(_ amount: String) -> Double? {
        Double(amount)
    }
    
    func isValidConversion(fromAmount: String, toAmount: String, isLoading: Bool) -> Bool {
        !toAmount.isEmpty &&
        toAmount != "0.00" &&
        !isLoading &&
        isValidAmount(fromAmount)
    }
}
