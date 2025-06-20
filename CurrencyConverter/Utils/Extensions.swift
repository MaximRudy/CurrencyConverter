import Foundation

// MARK: - Date Extensions
extension DateFormatter {
    static let shortTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
}

// MARK: - String Extensions
extension String {
    var isValidNumber: Bool {
        return Double(self) != nil
    }
    
    func limitLength(_ length: Int) -> String {
        if self.count <= length {
            return self
        } else {
            return String(self.prefix(length))
        }
    }
    
    var isValidAmount: Bool {
        guard !isEmpty else { return false }
        return Double(self) != nil && Double(self)! > 0
    }
    
    func currencySymbol(for currency: Currency) -> String {
        return "\(currency.symbol)\(self)"
    }
}
