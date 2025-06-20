import SwiftUI

struct HistoryListView: View {
    @ObservedObject var viewModel: HistoryViewModel
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        List {
            ForEach(viewModel.filteredHistory) { record in
                HistoryRow(record: record)
                    .listRowBackground(Color.clear)
                    .listRowSeparatorTint(themeManager.colors.secondary.opacity(0.3))
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        swipeActions(for: record)
                    }
            }
        }
        .listStyle(PlainListStyle())
        .scrollContentBackground(.hidden)
    }
    
    @ViewBuilder
    private func swipeActions(for record: ConversionRecord) -> some View {
        Button(role: .destructive) {
            withAnimation {
                viewModel.deleteRecord(record)
            }
        } label: {
            Label("Delete", systemImage: "trash")
        }
        
        Button {
            withAnimation {
                viewModel.toggleFavorite(record)
            }
        } label: {
            Label(
                viewModel.isFavorite(record) ? "Unfavorite" : "Favorite",
                systemImage: viewModel.isFavorite(record) ? "heart.slash" : "heart"
            )
        }
        .tint(themeManager.colors.warning)
    }
}
