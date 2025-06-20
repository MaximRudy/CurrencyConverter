import Foundation

struct FavoriteConversion: Codable, Identifiable, Equatable {
    var id = UUID()
    let fromCurrency: Currency
    let toCurrency: Currency
    
    var displayName: String {
        "\(fromCurrency.rawValue)/\(toCurrency.rawValue)"
    }
    
    static func == (lhs: FavoriteConversion, rhs: FavoriteConversion) -> Bool {
        lhs.id == rhs.id
    }
}
