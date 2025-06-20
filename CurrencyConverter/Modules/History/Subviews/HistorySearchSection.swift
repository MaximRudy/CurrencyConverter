import SwiftUI

struct HistorySearchSection: View {
    @ObservedObject var viewModel: HistoryViewModel
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 12) {
            searchBar
            statisticsCards
        }
        .padding()
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(themeManager.colors.secondaryText)
            
            TextField("Search conversions...", text: $viewModel.searchText)
                .foregroundColor(themeManager.colors.text)
                .textFieldStyle(PlainTextFieldStyle())
            
            if !viewModel.searchText.isEmpty {
                Button(action: { viewModel.searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(themeManager.colors.secondaryText)
                }
            }
        }
        .padding()
        .background(searchBarBackground)
    }
    
    private var searchBarBackground: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(themeManager.colors.cardBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(themeManager.colors.secondary.opacity(0.3), lineWidth: 1)
            )
    }
    
    private var statisticsCards: some View {
        HStack(spacing: 16) {
            StatCard(
                title: "Total",
                value: "\(viewModel.conversionHistory.count)",
                icon: "number.circle",
                color: themeManager.colors.primary
            )
            
            StatCard(
                title: "This Month",
                value: "\(viewModel.thisMonthCount)",
                icon: "calendar.circle",
                color: themeManager.colors.accent
            )
            
            StatCard(
                title: "Favorites",
                value: "\(viewModel.favoritePairsCount)",
                icon: "heart.circle",
                color: themeManager.colors.success
            )
        }
    }
}
