import SwiftUI

struct ExchangeRateInfoCard: View {
    let fromCurrency: Currency
    let toCurrency: Currency
    let exchangeRate: Double
    let errorMessage: String?
    
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: LayoutConstants.smallSpacing) {
            headerSection
            
            if let errorMessage = errorMessage {
                errorSection(errorMessage)
            }
        }
        .padding(LayoutConstants.smallSpacing)
        .background(cardBackground)
    }
    
    private var headerSection: some View {
        VStack {
            Text("Exchange Rate")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(themeManager.colors.text)
            
            Spacer()
            
            if exchangeRate > 0 {
                exchangeRateText
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private var exchangeRateText: some View {
        Text("1 \(fromCurrency.rawValue) = \(exchangeRate, specifier: "%.4f") \(toCurrency.rawValue)")
            .font(.subheadline)
            .fontWeight(.medium)
            .foregroundColor(themeManager.colors.accent)
    }
    
    private func errorSection(_ message: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(themeManager.colors.error)
            
            Text(message)
                .font(.caption)
                .foregroundColor(themeManager.colors.error)
            
            Spacer()
        }
        .padding(.top, 4)
    }
    
    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: LayoutConstants.inputCornerRadius)
            .fill(themeManager.colors.cardBackground.opacity(0.5))
            .overlay(
                RoundedRectangle(cornerRadius: LayoutConstants.inputCornerRadius)
                    .stroke(themeManager.colors.secondary.opacity(0.2), lineWidth: 1)
            )
    }
}
