import SwiftUI

struct BackgroundGradientView: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
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
}
