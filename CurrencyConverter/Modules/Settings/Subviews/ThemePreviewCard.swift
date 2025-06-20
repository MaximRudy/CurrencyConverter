import SwiftUI

struct ThemePreviewCard: View {
    let theme: AppTheme
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(theme.colors.background)
                        .frame(height: 100)
                    
                    VStack(spacing: 8) {
                        HStack(spacing: 8) {
                            Circle()
                                .fill(theme.colors.primary)
                                .frame(width: 16, height: 16)
                            
                            Rectangle()
                                .fill(theme.colors.text)
                                .frame(width: 40, height: 4)
                                .cornerRadius(2)
                            
                            Spacer()
                        }
                        
                        HStack(spacing: 4) {
                            Rectangle()
                                .fill(theme.colors.accent)
                                .frame(width: 30, height: 8)
                                .cornerRadius(4)
                            
                            Rectangle()
                                .fill(theme.colors.secondary)
                                .frame(width: 20, height: 8)
                                .cornerRadius(4)
                            
                            Spacer()
                        }
                        
                        HStack(spacing: 4) {
                            Rectangle()
                                .fill(theme.colors.secondaryText)
                                .frame(width: 50, height: 6)
                                .cornerRadius(3)
                            
                            Spacer()
                        }
                    }
                    .padding(12)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(theme.colors.cardBackground, lineWidth: 1)
                )
                
                VStack(spacing: 4) {
                    HStack {
                        Image(systemName: theme.icon)
                            .foregroundColor(theme.colors.primary)
                        
                        Text(theme.displayName)
                            .font(.headline)
                            .fontWeight(.medium)
                            .foregroundColor(ThemeManager.shared.colors.text)
                        
                        Spacer()
                        
                        if isSelected {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(ThemeManager.shared.colors.accent)
                        }
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(ThemeManager.shared.colors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                isSelected ? ThemeManager.shared.colors.accent : Color.clear,
                                lineWidth: 2
                            )
                    )
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .shadow(
                color: isSelected ? ThemeManager.shared.colors.accent.opacity(0.3) : Color.clear,
                radius: isSelected ? 8 : 0
            )
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}
