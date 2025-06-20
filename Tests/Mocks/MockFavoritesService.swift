import UIKit
@testable import CurrencyConverter

final class MockFavoritesService: FavoritesServiceProtocol {
    var favorites: [FavoriteConversion] = []
    var addFavoriteCalled = false
    var removeFavoriteCalled = false
    var loadFavoritesCalled = false
    
    func loadFavorites() -> [FavoriteConversion] {
        loadFavoritesCalled = true
        return favorites
    }
    
    func addFavorite(_ favorite: FavoriteConversion) throws {
        addFavoriteCalled = true
        favorites.append(favorite)
    }
    
    func removeFavorite(_ favorite: FavoriteConversion) throws {
        removeFavoriteCalled = true
        favorites.removeAll { $0.id == favorite.id }
    }
}
