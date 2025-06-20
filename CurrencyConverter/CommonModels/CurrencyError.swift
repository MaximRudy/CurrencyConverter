import Foundation

enum CurrencyError: Error, LocalizedError {
    case invalidURL
    case networkError
    case decodingError
    case noData
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .networkError:
            return "Network error occurred"
        case .decodingError:
            return "Failed to decode response"
        case .noData:
            return "No data available"
        }
    }
}
