import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                themeManager.colors.background
                    .ignoresSafeArea()
                
                Form {
                    ThemeSection(viewModel: viewModel)
                    GeneralSection(viewModel: viewModel)
                    UpdatesSection(viewModel: viewModel)
                    InterfaceSection(viewModel: viewModel)
                    DataSection(viewModel: viewModel)
                    AboutSection(viewModel: viewModel)
                }
                .scrollContentBackground(.hidden)
                .scrollIndicators(.hidden)
                .background(themeManager.colors.background)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $viewModel.showingThemeSelector) {
                ThemeSelectorView()
                    .environmentObject(themeManager)
            }
        }
        .accentColor(themeManager.colors.accent)
        .environmentObject(viewModel)
    }
}
