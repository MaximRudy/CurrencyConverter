import SwiftUI

struct SettingRow: View {
    @EnvironmentObject var themeManager: ThemeManager
    let icon: String
    let title: String
    var subtitle: String?
    var value: String?
    var showChevron = false
    var action: (() -> Void)?
    
    var body: some View {
        HStack {
            SettingIcon(systemName: icon)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .foregroundColor(themeManager.colors.text)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(themeManager.colors.secondaryText)
                }
            }
            
            Spacer()
            
            if let value = value {
                Text(value)
                    .foregroundColor(themeManager.colors.secondaryText)
            }
            
            if showChevron {
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(themeManager.colors.secondaryText)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            action?()
        }
    }
}
