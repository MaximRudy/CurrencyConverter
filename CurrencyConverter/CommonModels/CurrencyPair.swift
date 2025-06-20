import Foundation

struct CurrencyPair: Codable, Hashable {
    let from: Currency
    let to: Currency
    
    var displayName: String {
        return "\(from.rawValue)/\(to.rawValue)"
    }
}
