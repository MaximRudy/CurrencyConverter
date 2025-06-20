import SwiftUI

enum AppTheme: String, CaseIterable, Identifiable {
    case system = "system"
    case light = "light"
    case dark = "dark"
    case blue = "blue"
    case green = "green"
    case purple = "purple"
    case orange = "orange"
    case red = "red"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .system: return "System"
        case .light: return "Light"
        case .dark: return "Dark"
        case .blue: return "Ocean Blue"
        case .green: return "Forest Green"
        case .purple: return "Royal Purple"
        case .orange: return "Sunset Orange"
        case .red: return "Cherry Red"
        }
    }
    
    var icon: String {
        switch self {
        case .system: return "gear"
        case .light: return "sun.max"
        case .dark: return "moon"
        case .blue: return "drop"
        case .green: return "leaf"
        case .purple: return "crown"
        case .orange: return "sunset"
        case .red: return "heart"
        }
    }
    
    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark, .blue, .green, .purple, .orange, .red: return .dark
        }
    }
    
    var colors: ThemeColors {
        switch self {
        case .system, .light:
            return ThemeColors(
                primary: Color.blue,
                secondary: Color.gray,
                accent: Color.blue,
                background: Color(.systemBackground),
                secondaryBackground: Color(.secondarySystemBackground),
                cardBackground: Color(.systemGray6),
                text: Color.primary,
                secondaryText: Color.secondary,
                success: Color.green,
                warning: Color.orange,
                error: Color.red
            )
        case .dark:
            return ThemeColors(
                primary: Color.blue,
                secondary: Color.gray,
                accent: Color.cyan,
                background: Color.black,
                secondaryBackground: Color(.systemGray6),
                cardBackground: Color(.systemGray5),
                text: Color.white,
                secondaryText: Color.gray,
                success: Color.green,
                warning: Color.orange,
                error: Color.red
            )
        case .blue:
            return ThemeColors(
                primary: Color(red: 0.1, green: 0.4, blue: 0.8),
                secondary: Color(red: 0.3, green: 0.6, blue: 0.9),
                accent: Color(red: 0.0, green: 0.7, blue: 1.0),
                background: Color(red: 0.05, green: 0.1, blue: 0.2),
                secondaryBackground: Color(red: 0.1, green: 0.2, blue: 0.3),
                cardBackground: Color(red: 0.15, green: 0.25, blue: 0.35),
                text: Color.white,
                secondaryText: Color(red: 0.8, green: 0.9, blue: 1.0),
                success: Color(red: 0.2, green: 0.8, blue: 0.6),
                warning: Color(red: 1.0, green: 0.8, blue: 0.2),
                error: Color(red: 1.0, green: 0.4, blue: 0.4)
            )
        case .green:
            return ThemeColors(
                primary: Color(red: 0.2, green: 0.7, blue: 0.3),
                secondary: Color(red: 0.4, green: 0.8, blue: 0.4),
                accent: Color(red: 0.1, green: 0.9, blue: 0.4),
                background: Color(red: 0.05, green: 0.15, blue: 0.05),
                secondaryBackground: Color(red: 0.1, green: 0.25, blue: 0.1),
                cardBackground: Color(red: 0.15, green: 0.3, blue: 0.15),
                text: Color.white,
                secondaryText: Color(red: 0.8, green: 1.0, blue: 0.8),
                success: Color(red: 0.3, green: 0.9, blue: 0.3),
                warning: Color(red: 1.0, green: 0.8, blue: 0.2),
                error: Color(red: 1.0, green: 0.4, blue: 0.4)
            )
        case .purple:
            return ThemeColors(
                primary: Color(red: 0.6, green: 0.2, blue: 0.8),
                secondary: Color(red: 0.7, green: 0.4, blue: 0.9),
                accent: Color(red: 0.8, green: 0.3, blue: 1.0),
                background: Color(red: 0.1, green: 0.05, blue: 0.2),
                secondaryBackground: Color(red: 0.2, green: 0.1, blue: 0.3),
                cardBackground: Color(red: 0.25, green: 0.15, blue: 0.35),
                text: Color.white,
                secondaryText: Color(red: 0.9, green: 0.8, blue: 1.0),
                success: Color(red: 0.6, green: 0.8, blue: 0.2),
                warning: Color(red: 1.0, green: 0.8, blue: 0.2),
                error: Color(red: 1.0, green: 0.4, blue: 0.4)
            )
        case .orange:
            return ThemeColors(
                primary: Color(red: 1.0, green: 0.6, blue: 0.2),
                secondary: Color(red: 1.0, green: 0.7, blue: 0.4),
                accent: Color(red: 1.0, green: 0.8, blue: 0.0),
                background: Color(red: 0.2, green: 0.1, blue: 0.05),
                secondaryBackground: Color(red: 0.3, green: 0.2, blue: 0.1),
                cardBackground: Color(red: 0.35, green: 0.25, blue: 0.15),
                text: Color.white,
                secondaryText: Color(red: 1.0, green: 0.9, blue: 0.8),
                success: Color(red: 0.2, green: 0.8, blue: 0.6),
                warning: Color(red: 1.0, green: 0.9, blue: 0.3),
                error: Color(red: 1.0, green: 0.4, blue: 0.4)
            )
        case .red:
            return ThemeColors(
                primary: Color(red: 0.8, green: 0.2, blue: 0.3),
                secondary: Color(red: 0.9, green: 0.4, blue: 0.4),
                accent: Color(red: 1.0, green: 0.3, blue: 0.4),
                background: Color(red: 0.15, green: 0.05, blue: 0.05),
                secondaryBackground: Color(red: 0.25, green: 0.1, blue: 0.1),
                cardBackground: Color(red: 0.3, green: 0.15, blue: 0.15),
                text: Color.white,
                secondaryText: Color(red: 1.0, green: 0.8, blue: 0.8),
                success: Color(red: 0.2, green: 0.8, blue: 0.6),
                warning: Color(red: 1.0, green: 0.8, blue: 0.2),
                error: Color(red: 1.0, green: 0.5, blue: 0.5)
            )
        }
    }
}
