import SwiftUI

struct CurrencyConverterAppView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @State private var selectedTab = 0
    @State private var showingNetworkAlert = false
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                CurrencyConverterView()
                    .tabItem {
                        Image(systemName: "dollarsign.circle")
                        Text("Convert")
                    }
                    .tag(0)
                
                HistoryView()
                    .tabItem {
                        Image(systemName: "clock.arrow.circlepath")
                        Text("History")
                    }
                    .tag(1)
                
                SettingsView()
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                    .tag(2)
            }
            .accentColor(themeManager.colors.accent)
            .background(themeManager.colors.background)
            
            if !networkMonitor.isConnected {
                VStack {
                    Spacer()
                    
                    HStack {
                        Image(systemName: "wifi.slash")
                            .foregroundColor(.white)
                        
                        Text("No Internet Connection")
                            .foregroundColor(.white)
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(themeManager.colors.error)
                    )
                    .padding(.bottom, 100)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.easeInOut(duration: 0.3), value: networkMonitor.isConnected)
            }
        }
        .onReceive(networkMonitor.$isConnected) { isConnected in
            if !isConnected {
                HapticFeedback.shared.notification(.warning)
            }
        }
    }
}

#Preview {
    CurrencyConverterAppView()
        .environmentObject(ThemeManager.shared)
        .environmentObject(NetworkMonitor())
}
