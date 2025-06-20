import SwiftUI

struct SwapCurrencyButton: View {
    let isLoading: Bool
    let action: () -> Void
    
    @EnvironmentObject var themeManager: ThemeManager
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "arrow.up.arrow.down")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(themeManager.colors.background)
                .frame(
                    width: LayoutConstants.swapButtonSize,
                    height: LayoutConstants.swapButtonSize
                )
                .background(buttonBackground)
        }
        .disabled(isLoading)
        .scaleEffect(isPressed ? 0.9 : 1.0)
        .scaleEffect(isLoading ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isPressed)
        .animation(.easeInOut(duration: 0.2), value: isLoading)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
    
    private var buttonBackground: some View {
        Circle()
            .fill(buttonGradient)
            .shadow(
                color: themeManager.colors.accent.opacity(0.3),
                radius: 8,
                x: 0,
                y: 4
            )
    }
    
    private var buttonGradient: LinearGradient {
        LinearGradient(
            colors: [
                themeManager.colors.accent.opacity(isLoading ? 0.6 : 1.0),
                themeManager.colors.primary.opacity(isLoading ? 0.6 : 1.0)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
