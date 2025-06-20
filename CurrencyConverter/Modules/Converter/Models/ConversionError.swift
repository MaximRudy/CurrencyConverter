import Foundation

enum ConversionError: LocalizedError {
    case invalidAmount
    
    var errorDescription: String? {
        switch self {
        case .invalidAmount:
            return "Invalid amount entered"
        }
    }
}
