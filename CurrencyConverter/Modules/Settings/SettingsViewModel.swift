import SwiftUI
import Combine

@MainActor
final class SettingsViewModel: ObservableObject {
    
    @AppStorage("autoRefreshInterval") var autoRefreshInterval: Double = 300
    @AppStorage("hapticFeedbackEnabled") var hapticFeedbackEnabled: Bool = true
    @AppStorage("showRateChanges") var showRateChanges: Bool = true
    @AppStorage("defaultFromCurrency") var defaultFromCurrency: String = Currency.usd.rawValue
    @AppStorage("defaultToCurrency") var defaultToCurrency: String = Currency.rub.rawValue
    
    @Published var showingThemeSelector = false
    
    var autoRefreshIntervalText: String {
        "\(Int(autoRefreshInterval / 60)) min"
    }
    
    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }
    
    func clearCache() {
        HapticFeedback.shared.notification(.success)
    }
    
    func clearHistory() {
        HapticFeedback.shared.notification(.warning)
    }
    
    func openPrivacyPolicy() {
        guard let url = URL(string: "https://yourapp.com/privacy") else { return }
        UIApplication.shared.open(url)
    }
    
    func showThemeSelector() {
        showingThemeSelector = true
    }
}
