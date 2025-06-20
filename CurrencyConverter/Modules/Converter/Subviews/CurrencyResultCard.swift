import SwiftUI

struct CurrencyResultCard: View {
    let title: String
    let currency: Currency
    let amount: String
    let isLoading: Bool
    let onCurrencyTap: () -> Void
    
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: LayoutConstants.mediumSpacing) {
            titleLabel
            currencySelector
            resultDisplay
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
    
    @ViewBuilder
    private var resultDisplay: some View {
        HStack {
            if isLoading {
                loadingView
            } else {
                resultView
            }
            
            Spacer()
        }
        .padding(LayoutConstants.inputPadding)
        .background(resultBackground)
    }
    
    private var loadingView: some View {
        HStack(spacing: 12) {
            ProgressView()
                .scaleEffect(0.8)
                .tint(themeManager.colors.accent)
            
            Text("Converting...")
                .font(.title2)
                .foregroundColor(themeManager.colors.secondaryText)
        }
        .transition(.opacity.combined(with: .scale))
    }
    
    private var resultView: some View {
        Text(amount)
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(themeManager.colors.accent)
            .transition(.opacity.combined(with: .scale))
    }
    
    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: LayoutConstants.cardCornerRadius)
            .fill(themeManager.colors.cardBackground)
            .shadow(
                color: themeManager.colors.accent.opacity(0.1),
                radius: 8,
                x: 0,
                y: 4
            )
    }
    
    private var resultBackground: some View {
        RoundedRectangle(cornerRadius: LayoutConstants.inputCornerRadius)
            .fill(themeManager.colors.background)
            .overlay(
                RoundedRectangle(cornerRadius: LayoutConstants.inputCornerRadius)
                    .stroke(themeManager.colors.success.opacity(0.3), lineWidth: 2)
            )
    }
}
