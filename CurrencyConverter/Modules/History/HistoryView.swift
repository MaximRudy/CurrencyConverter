import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @StateObject private var viewModel = HistoryViewModel()
    @State private var showingExportOptions = false
    @State private var showingFilterOptions = false
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundGradient
                
                VStack(spacing: 0) {
                    if !viewModel.conversionHistory.isEmpty {
                        HistorySearchSection(viewModel: viewModel)
                            .environmentObject(themeManager)
                    }
                    
                    contentView
                }
            }
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    navigationBarButtons
                }
            }
            .onAppear {
                viewModel.loadHistory()
            }
            .sheet(isPresented: $showingExportOptions) {
                ExportOptionsView(history: viewModel.filteredHistory)
                    .environmentObject(themeManager)
            }
            .sheet(isPresented: $showingFilterOptions) {
                FilterOptionsView(viewModel: viewModel)
                    .environmentObject(themeManager)
            }
        }
        .accentColor(themeManager.colors.accent)
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                themeManager.colors.background,
                themeManager.colors.secondaryBackground
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    private var contentView: some View {
        if viewModel.filteredHistory.isEmpty {
            HistoryEmptyStateView()
                .environmentObject(themeManager)
        } else {
            HistoryListView(viewModel: viewModel)
                .environmentObject(themeManager)
        }
    }
    
    @ViewBuilder
    private var navigationBarButtons: some View {
        if !viewModel.conversionHistory.isEmpty {
            HStack(spacing: 16) {
                Button(action: { showingFilterOptions = true }) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .foregroundColor(themeManager.colors.accent)
                }
                
                Button(action: { showingExportOptions = true }) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(themeManager.colors.accent)
                }
            }
        }
    }
}

#Preview {
    HistoryView()
        .environmentObject(ThemeManager.shared)
}
