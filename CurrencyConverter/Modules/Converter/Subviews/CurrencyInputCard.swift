import SwiftUI

struct CurrencyInputCard: View {
    let title: String
    let currency: Currency
    @Binding var amount: String
    let onCurrencyTap: () -> Void
    
    @EnvironmentObject var themeManager: ThemeManager
    @FocusState private var isAmountFocused: Bool
    
    var body: some View {
        VStack(spacing: LayoutConstants.mediumSpacing) {
            titleLabel
            currencySelector
            amountInput
        }
        .padding(LayoutConstants.cardPadding)
        .background(cardBackground)
    }
    
    private var titleLabel: some View {
        HStack {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(themeManager.colors.secondaryText)
            
            Spacer()
        }
    }
    
    private var currencySelector: some View {
        CurrencySelectorButton(
            currency: currency,
            action: onCurrencyTap
        )
        .environmentObject(themeManager)
    }
    
    private var amountInput: some View {
        TextField("Enter amount", text: $amount)
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(themeManager.colors.text)
            .keyboardType(.decimalPad)
            .focused($isAmountFocused)
            .padding(LayoutConstants.inputPadding)
            .background(inputBackground)
    }
    
    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: LayoutConstants.cardCornerRadius)
            .fill(themeManager.colors.cardBackground)
            .shadow(
                color: themeManager.colors.primary.opacity(0.1),
                radius: 8,
                x: 0,
                y: 4
            )
    }
    
    private var inputBackground: some View {
        RoundedRectangle(cornerRadius: LayoutConstants.inputCornerRadius)
            .fill(themeManager.colors.background)
            .overlay(
                RoundedRectangle(cornerRadius: LayoutConstants.inputCornerRadius)
                    .stroke(
                        isAmountFocused ? themeManager.colors.accent : themeManager.colors.accent.opacity(0.3),
                        lineWidth: isAmountFocused ? 2 : 1
                    )
            )
            .animation(.easeInOut(duration: 0.2), value: isAmountFocused)
    }
}
