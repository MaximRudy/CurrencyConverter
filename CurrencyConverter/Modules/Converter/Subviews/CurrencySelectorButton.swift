import SwiftUI

struct CurrencySelectorButton: View {
    let currency: Currency
    let action: () -> Void
    
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: LayoutConstants.smallSpacing) {
                currencyFlag
                currencyInfo
                Spacer()
                chevronIcon
            }
            .padding(LayoutConstants.buttonPadding)
            .background(buttonBackground)
        }
        .buttonStyle(ScaleButtonStyle())
    }
    
    private var currencyFlag: some View {
        Text(currency.flag)
            .font(.title2)
    }
    
    private var currencyInfo: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(currency.rawValue)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(themeManager.colors.text)
            
            Text(currency.name)
                .font(.caption)
                .foregroundColor(themeManager.colors.secondaryText)
        }
    }
    
    private var chevronIcon: some View {
        Image(systemName: "chevron.down")
            .font(.caption)
            .foregroundColor(themeManager.colors.secondaryText)
    }
    
    private var buttonBackground: some View {
        RoundedRectangle(cornerRadius: LayoutConstants.buttonCornerRadius)
            .fill(themeManager.colors.cardBackground)
            .overlay(
                RoundedRectangle(cornerRadius: LayoutConstants.buttonCornerRadius)
                    .stroke(themeManager.colors.secondary.opacity(0.3), lineWidth: 1)
            )
    }
}

struct ScaleButtonStyle: ButtonStyle {
    let scaleEffect: CGFloat
    
    init(scaleEffect: CGFloat = 0.95) {
        self.scaleEffect = scaleEffect
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scaleEffect : 1.0)
            .animation(.easeInOut(duration: LayoutConstants.quickAnimationDuration), value: configuration.isPressed)
    }
}
