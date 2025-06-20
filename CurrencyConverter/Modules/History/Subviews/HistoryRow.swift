import SwiftUI

struct HistoryRow: View {
    @EnvironmentObject var themeManager: ThemeManager
    let record: ConversionRecord

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                HStack(spacing: 8) {
                    Text(record.fromCurrency.flag)
                        .font(.title3)
                    
                    Image(systemName: "arrow.right")
                        .font(.caption)
                        .foregroundColor(themeManager.colors.secondaryText)
                    
                    Text(record.toCurrency.flag)
                        .font(.title3)
                    
                    Text("\(record.fromCurrency.rawValue)/\(record.toCurrency.rawValue)")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(themeManager.colors.text)
                }
                
                Spacer()
                
                Text(record.timestamp, style: .relative)
                    .font(.caption)
                    .foregroundColor(themeManager.colors.secondaryText)
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("\(record.fromAmount, specifier: "%.2f")")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(themeManager.colors.text)
                        
                        Text(record.fromCurrency.rawValue)
                            .font(.caption)
                            .foregroundColor(themeManager.colors.secondaryText)
                    }
                    
                    HStack {
                        Text("\(record.toAmount, specifier: "%.2f")")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(themeManager.colors.accent)
                        
                        Text(record.toCurrency.rawValue)
                            .font(.caption)
                            .foregroundColor(themeManager.colors.secondaryText)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Rate")
                        .font(.caption)
                        .foregroundColor(themeManager.colors.secondaryText)
                    
                    Text("\(record.rate, specifier: "%.4f")")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(themeManager.colors.primary)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(themeManager.colors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(themeManager.colors.secondary.opacity(0.2), lineWidth: 1)
                )
        )
        .padding(.horizontal, 4)
    }
}
