import SwiftUI

struct ConverterHeaderView: View {
    let lastUpdateTime: Date?
    let isLoading: Bool
    
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: LayoutConstants.smallSpacing) {
            updateTimeView
        }
    }
    
    @ViewBuilder
    private var updateTimeView: some View {
        if isLoading {
            HStack(spacing: 8) {
                ProgressView()
                    .scaleEffect(0.7)
                    .tint(themeManager.colors.accent)
                
                Text("Updating rates...")
                    .font(.caption)
                    .foregroundColor(themeManager.colors.secondaryText)
            }
            .transition(.opacity)
        } else if let lastUpdate = lastUpdateTime {
            Text("Updated \(lastUpdate, style: .relative) ago")
                .font(.caption)
                .foregroundColor(themeManager.colors.secondaryText)
                .transition(.opacity)
        }
    }
}
