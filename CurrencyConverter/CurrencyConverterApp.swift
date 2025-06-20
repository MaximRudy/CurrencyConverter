import SwiftUI

@main
struct CurrencyConverterApp: App {
    @StateObject private var themeManager = ThemeManager.shared
    @StateObject private var networkMonitor = NetworkMonitor()
    
    var body: some Scene {
        WindowGroup {
            CurrencyConverterAppView()
                .environmentObject(themeManager)
                .environmentObject(networkMonitor)
                .preferredColorScheme(themeManager.currentTheme.colorScheme)
                .onAppear {
                    setupAppearance()
                }
                .onChange(of: themeManager.currentTheme) {
                    setupAppearance()
                }
        }
    }
}

extension CurrencyConverterApp {
    private func setupAppearance() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor(themeManager.colors.background)
        navBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor(themeManager.colors.text)
        ]
        navBarAppearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor(themeManager.colors.text)
        ]
        
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(themeManager.colors.background)
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        
        UITableView.appearance().backgroundColor = UIColor(themeManager.colors.background)
        UITableViewCell.appearance().backgroundColor = UIColor(themeManager.colors.background)
    }
}
