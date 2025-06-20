import SwiftUI

struct SectionHeader: View {
    @EnvironmentObject var themeManager: ThemeManager
    let title: String
    
    var body: some View {
        Text(title)
            .foregroundColor(themeManager.colors.secondaryText)
    }
}

struct SettingToggle: View {
    @EnvironmentObject var themeManager: ThemeManager
    let icon: String
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        Toggle(isOn: $isOn) {
            HStack {
                SettingIcon(systemName: icon)
                Text(title)
                    .foregroundColor(themeManager.colors.text)
            }
        }
        .toggleStyle(SwitchToggleStyle(tint: themeManager.colors.accent))
    }
}

struct SettingButton: View {
    @EnvironmentObject var themeManager: ThemeManager
    let icon: String
    let title: String
    var iconColor: Color?
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                SettingIcon(systemName: icon, color: iconColor)
                Text(title)
                    .foregroundColor(themeManager.colors.text)
            }
        }
    }
}

struct RefreshSlider: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var value: Double
    
    var body: some View {
        Slider(value: $value, in: 60...1800, step: 60) {
            Text("Refresh Interval")
        } minimumValueLabel: {
            Text("1m")
                .font(.caption)
                .foregroundColor(themeManager.colors.secondaryText)
        } maximumValueLabel: {
            Text("30m")
                .font(.caption)
                .foregroundColor(themeManager.colors.secondaryText)
        }
        .accentColor(themeManager.colors.accent)
    }
}

struct SettingIcon: View {
    @EnvironmentObject var themeManager: ThemeManager
    let systemName: String
    var color: Color?
    
    var body: some View {
        Image(systemName: systemName)
            .foregroundColor(color ?? themeManager.colors.accent)
            .frame(width: 24)
    }
}
