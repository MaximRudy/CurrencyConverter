import SwiftUI

struct ActionButtonsView: View {
    let canSave: Bool
    let isLoading: Bool
    let onSave: () -> Void
    let onRefresh: () -> Void
    
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        HStack(spacing: LayoutConstants.mediumSpacing) {
            saveButton
            refreshButton
        }
    }
    
    private var saveButton: some View {
        ActionButton(
            title: "Save",
            icon: "bookmark.fill",
            style: .filled,
            isEnabled: canSave && !isLoading,
            action: {
                onSave()
                HapticFeedback.shared.notification(.success)
            }
        )
        .environmentObject(themeManager)
    }
    
    private var refreshButton: some View {
        ActionButton(
            title: "Refresh",
            icon: "arrow.clockwise",
            style: .outlined,
            isEnabled: !isLoading,
            action: {
                onRefresh()
                HapticFeedback.shared.impact(.light)
            }
        )
        .environmentObject(themeManager)
    }
}
