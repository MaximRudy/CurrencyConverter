import SwiftUI

// MARK: - Theme Section
struct ThemeSection: View {
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var viewModel: SettingsViewModel
    
    var body: some View {
        Section {
            SettingRow(
                icon: themeManager.currentTheme.icon,
                title: "Theme",
                subtitle: themeManager.currentTheme.displayName,
                showChevron: true,
                action: viewModel.showThemeSelector
            )
        } header: {
            SectionHeader(title: "Appearance")
        }
        .listRowBackground(themeManager.colors.cardBackground)
    }
}

// MARK: - General Section
struct GeneralSection: View {
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var viewModel: SettingsViewModel
    
    var body: some View {
        Section {
            HStack {
                SettingIcon(systemName: "dollarsign.circle")
                
                Text("From Currency")
                    .foregroundColor(themeManager.colors.text)
                
                Spacer()
                
                Picker("", selection: $viewModel.defaultFromCurrency) {
                    ForEach(Currency.allCases, id: \.rawValue) { currency in
                        HStack {
                            Text(currency.flag)
                            Text(currency.rawValue)
                        }
                        .tag(currency.rawValue)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .accentColor(themeManager.colors.accent)
            }
        } header: {
            SectionHeader(title: "General")
        }
        .listRowBackground(themeManager.colors.cardBackground)
    }
}

// MARK: - Updates Section
struct UpdatesSection: View {
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var viewModel: SettingsViewModel
    
    var body: some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    SettingIcon(systemName: "arrow.clockwise.circle")
                    
                    Text("Auto Refresh Interval")
                        .foregroundColor(themeManager.colors.text)
                    
                    Spacer()
                    
                    Text(viewModel.autoRefreshIntervalText)
                        .foregroundColor(themeManager.colors.secondaryText)
                }
                
                RefreshSlider(value: $viewModel.autoRefreshInterval)
            }
            
            SettingToggle(
                icon: "chart.line.uptrend.xyaxis",
                title: "Show Rate Changes",
                isOn: $viewModel.showRateChanges
            )
        } header: {
            SectionHeader(title: "Updates")
        }
        .listRowBackground(themeManager.colors.cardBackground)
    }
}

// MARK: - Interface Section
struct InterfaceSection: View {
    @ObservedObject var viewModel: SettingsViewModel
    
    var body: some View {
        Section {
            SettingToggle(
                icon: "iphone.radiowaves.left.and.right",
                title: "Haptic Feedback",
                isOn: $viewModel.hapticFeedbackEnabled
            )
        } header: {
            SectionHeader(title: "Interface")
        }
        .listRowBackground(ThemeManager.shared.colors.cardBackground)
    }
}

// MARK: - Data Section
struct DataSection: View {
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var viewModel: SettingsViewModel
    
    var body: some View {
        Section {
            SettingButton(
                icon: "trash.circle",
                title: "Clear Cache",
                iconColor: themeManager.colors.warning,
                action: viewModel.clearCache
            )
            
            SettingButton(
                icon: "clock.arrow.trianglehead.counterclockwise.rotate.90",
                title: "Clear History",
                iconColor: themeManager.colors.error,
                action: viewModel.clearHistory
            )
        } header: {
            SectionHeader(title: "Data")
        }
        .listRowBackground(themeManager.colors.cardBackground)
    }
}

// MARK: - About Section
struct AboutSection: View {
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var viewModel: SettingsViewModel
    
    var body: some View {
        Section {
            SettingRow(
                icon: "info.circle",
                title: "Version",
                value: viewModel.appVersion
            )
            
            SettingRow(
                icon: "hand.raised.circle",
                title: "Privacy Policy",
                showChevron: true,
                action: viewModel.openPrivacyPolicy
            )
        } header: {
            SectionHeader(title: "About")
        }
        .listRowBackground(themeManager.colors.cardBackground)
    }
}
