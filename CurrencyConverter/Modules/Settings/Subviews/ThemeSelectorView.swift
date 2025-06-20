import SwiftUI

struct ThemeSelectorView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedTheme: AppTheme
    
    init() {
        _selectedTheme = State(initialValue: ThemeManager.shared.currentTheme)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                themeManager.colors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        ForEach(AppTheme.allCases) { theme in
                            ThemePreviewCard(
                                theme: theme,
                                isSelected: selectedTheme == theme
                            ) {
                                selectTheme(theme)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Choose Theme")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Done") {
                    themeManager.setTheme(selectedTheme)
                    presentationMode.wrappedValue.dismiss()
                }
                    .fontWeight(.semibold)
            )
        }
        .accentColor(themeManager.colors.accent)
    }
    
    private func selectTheme(_ theme: AppTheme) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            selectedTheme = theme
        }
        HapticFeedback.shared.impact(.light)
    }
}

#Preview {
    ThemeSelectorView()
        .environmentObject(ThemeManager.shared)
}
