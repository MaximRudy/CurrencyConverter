import Foundation

protocol FavoritesServiceProtocol {
    func loadFavorites() -> [FavoriteConversion]
    func addFavorite(_ favorite: FavoriteConversion) throws
    func removeFavorite(_ favorite: FavoriteConversion) throws
}

final class FavoritesService: FavoritesServiceProtocol {
    private let userDefaults: UserDefaults
    private let key = "favoriteConversions"
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func loadFavorites() -> [FavoriteConversion] {
        guard let data = userDefaults.data(forKey: key),
              let favorites = try? JSONDecoder().decode([FavoriteConversion].self, from: data) else {
            return []
        }
        return favorites
    }
    
    func addFavorite(_ favorite: FavoriteConversion) throws {
        var favorites = loadFavorites()
        
        guard !favorites.contains(where: {
            $0.fromCurrency == favorite.fromCurrency && $0.toCurrency == favorite.toCurrency
        }) else { return }
        
        favorites.append(favorite)
        try saveFavorites(favorites)
    }
    
    func removeFavorite(_ favorite: FavoriteConversion) throws {
        var favorites = loadFavorites()
        favorites.removeAll { $0.id == favorite.id }
        try saveFavorites(favorites)
    }
    
    private func saveFavorites(_ favorites: [FavoriteConversion]) throws {
        let data = try JSONEncoder().encode(favorites)
        userDefaults.set(data, forKey: key)
    }
}
