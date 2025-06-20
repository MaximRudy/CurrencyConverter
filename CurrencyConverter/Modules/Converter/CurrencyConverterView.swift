import SwiftUI

struct CurrencyConverterView: View {
    @StateObject private var viewModel = CurrencyConverterViewModel()
    @EnvironmentObject var themeManager: ThemeManager
    @State private var showingCurrencyPicker = false
    @State private var isPickingFromCurrency = true
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundGradientView()
                    .environmentObject(themeManager)
                
                contentView
            }
            .navigationTitle("Currency Converter")
            .navigationBarTitleDisplayMode(.large)
            .refreshable {
                await viewModel.refreshRates()
            }
            .sheet(isPresented: $showingCurrencyPicker) {
                CurrencyPickerView(
                    selectedCurrency: isPickingFromCurrency ? $viewModel.fromCurrency : $viewModel.toCurrency,
                    isPresented: $showingCurrencyPicker
                )
                .environmentObject(themeManager)
            }
            .alert("Conversion Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") {
                    viewModel.clearError()
                }
            } message: {
                if let error = viewModel.errorMessage {
                    Text(error)
                }
            }
        }
        .accentColor(themeManager.colors.accent)
    }
    
    private var contentView: some View {
        ScrollView {
            LazyVStack(spacing: LayoutConstants.cardSpacing) {
                ConverterHeaderView(
                    lastUpdateTime: viewModel.lastUpdateTime,
                    isLoading: viewModel.isLoading
                )
                .environmentObject(themeManager)
                
                CurrencyInputCard(
                    title: "From",
                    currency: viewModel.fromCurrency,
                    amount: $viewModel.fromAmount,
                    onCurrencyTap: {
                        selectFromCurrency()
                    }
                )
                .environmentObject(themeManager)
                
                HStack(spacing: LayoutConstants.mediumSpacing) {
                    SwapCurrencyButton(
                        isLoading: viewModel.isLoading,
                        action: {
                            swapCurrencies()
                        }
                    )
                    .environmentObject(themeManager)

                    ExchangeRateInfoCard(
                        fromCurrency: viewModel.fromCurrency,
                        toCurrency: viewModel.toCurrency,
                        exchangeRate: viewModel.exchangeRate,
                        errorMessage: viewModel.errorMessage
                    )
                    .environmentObject(themeManager)
                }
                
                CurrencyResultCard(
                    title: "To",
                    currency: viewModel.toCurrency,
                    amount: viewModel.toAmount,
                    isLoading: viewModel.isLoading,
                    onCurrencyTap: {
                        selectToCurrency()
                    }
                )
                .environmentObject(themeManager)
                
                ActionButtonsView(
                    canSave: viewModel.canSaveConversion,
                    isLoading: viewModel.isLoading,
                    onSave: {
                        viewModel.saveConversion()
                    },
                    onRefresh: {
                        Task {
                            await viewModel.refreshRates()
                        }
                    }
                )
                .environmentObject(themeManager)
            }
            .padding(LayoutConstants.screenPadding)
        }
        .scrollIndicators(.hidden)
    }

    private func selectFromCurrency() {
        isPickingFromCurrency = true
        showingCurrencyPicker = true
        HapticFeedback.shared.impact(.light)
    }
    
    private func selectToCurrency() {
        isPickingFromCurrency = false
        showingCurrencyPicker = true
        HapticFeedback.shared.impact(.light)
    }
    
    private func swapCurrencies() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
            viewModel.swapCurrencies()
        }
        HapticFeedback.shared.impact(.medium)
    }
}

#Preview {
    CurrencyConverterView()
        .environmentObject(ThemeManager.shared)
}
