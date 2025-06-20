import SwiftUI

struct HistoryEmptyStateView: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 20) {
            emptyStateIcon
            emptyStateTitle
            emptyStateDescription
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(themeManager.colors.background)
    }
    
    private var emptyStateIcon: some View {
        Image(systemName: "clock.arrow.circlepath")
            .font(.system(size: 60))
            .foregroundColor(themeManager.colors.secondaryText)
    }
    
    private var emptyStateTitle: some View {
        Text("No Conversion History")
            .font(.title2)
            .fontWeight(.bold)
            .foregroundColor(themeManager.colors.text)
    }
    
    private var emptyStateDescription: some View {
        Text("Your currency conversions will appear here")
            .font(.body)
            .foregroundColor(themeManager.colors.secondaryText)
            .multilineTextAlignment(.center)
    }
}
