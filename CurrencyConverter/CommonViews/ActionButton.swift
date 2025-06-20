import SwiftUI

struct ActionButton: View {
    enum Style {
        case filled
        case outlined
    }
    
    let title: String
    let icon: String
    let style: Style
    let isEnabled: Bool
    let action: () -> Void
    
    @EnvironmentObject var themeManager: ThemeManager
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            .foregroundColor(foregroundColor)
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(buttonBackground)
        }
        .disabled(!isEnabled)
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .opacity(isEnabled ? 1.0 : 0.6)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .animation(.easeInOut(duration: 0.2), value: isEnabled)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            if isEnabled {
                isPressed = pressing
            }
        }, perform: {})
    }
    
    private var foregroundColor: Color {
        switch style {
        case .filled:
            return themeManager.colors.background
        case .outlined:
            return themeManager.colors.accent
        }
    }
    
    @ViewBuilder
    private var buttonBackground: some View {
        switch style {
        case .filled:
            RoundedRectangle(cornerRadius: 12)
                .fill(themeManager.colors.success)
        case .outlined:
            RoundedRectangle(cornerRadius: 12)
                .stroke(themeManager.colors.accent, lineWidth: 2)
        }
    }
}
