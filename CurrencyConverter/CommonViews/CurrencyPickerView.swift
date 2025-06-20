import SwiftUI

struct CurrencyPickerView: View {
    @Binding var selectedCurrency: Currency
    @Binding var isPresented: Bool
    @EnvironmentObject var themeManager: ThemeManager
    
    @State private var searchText = ""
    
    private var filteredCurrencies: [Currency] {
        if searchText.isEmpty {
            return Currency.allCases
        } else {
            return Currency.allCases.filter { currency in
                currency.rawValue.localizedCaseInsensitiveContains(searchText) ||
                currency.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                searchBar
                currencyList
            }
            .background(themeManager.colors.background)
            .navigationTitle("Select Currency")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                    .foregroundColor(themeManager.colors.accent)
                }
            }
        }
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(themeManager.colors.secondaryText)
            
            TextField("Search currencies", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
                .foregroundColor(themeManager.colors.text)
            
            if !searchText.isEmpty {
                Button(action: { searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(themeManager.colors.secondaryText)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(themeManager.colors.cardBackground)
        )
        .padding()
    }
    
    private var currencyList: some View {
        List(filteredCurrencies, id: \.self) { currency in
            CurrencyRow(
                currency: currency,
                isSelected: currency == selectedCurrency
            ) {
                selectedCurrency = currency
                HapticFeedback.shared.selection()
                isPresented = false
            }
            .environmentObject(themeManager)
            .listRowBackground(themeManager.colors.background)
        }
        .listStyle(PlainListStyle())
        .scrollIndicators(.hidden)
    }
}

struct CurrencyRow: View {
    let currency: Currency
    let isSelected: Bool
    let action: () -> Void
    
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        HStack(spacing: 16) {
            Text(currency.flag)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(currency.rawValue)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(themeManager.colors.text)
                
                Text(currency.name)
                    .font(.caption)
                    .foregroundColor(themeManager.colors.secondaryText)
            }
            
            Spacer()
            
            if isSelected {
                Image(systemName: "checkmark")
                    .foregroundColor(themeManager.colors.accent)
                    .fontWeight(.bold)
            }
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .onTapGesture {
            action()
        }
    }
}
