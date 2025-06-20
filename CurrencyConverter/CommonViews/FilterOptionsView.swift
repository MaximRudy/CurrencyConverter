import SwiftUI

struct FilterOptionsView: View {
    @ObservedObject var viewModel: HistoryViewModel
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                themeManager.colors.background
                    .ignoresSafeArea()
                
                Form {
                    dateRangeSection
                    currencySection
                    amountRangeSection
                    sortingSection
                    actionsSection
                }
                .scrollContentBackground(.hidden)
                .background(themeManager.colors.background)
            }
            .navigationTitle("Filter Options")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Reset") {
                    viewModel.resetFilters()
                    HapticFeedback.shared.impact(.light)
                }
                    .foregroundColor(themeManager.colors.warning),
                
                trailing: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
                    .foregroundColor(themeManager.colors.accent)
            )
        }
    }
    
    private var dateRangeSection: some View {
        Section {
            DatePicker(
                "From Date",
                selection: $viewModel.filterStartDate,
                displayedComponents: .date
            )
            .foregroundColor(themeManager.colors.text)
            .accentColor(themeManager.colors.accent)
            
            DatePicker(
                "To Date",
                selection: $viewModel.filterEndDate,
                displayedComponents: .date
            )
            .foregroundColor(themeManager.colors.text)
            .accentColor(themeManager.colors.accent)
            
            Toggle("Enable Date Filter", isOn: $viewModel.isDateFilterEnabled)
                .foregroundColor(themeManager.colors.text)
                .toggleStyle(SwitchToggleStyle(tint: themeManager.colors.accent))
        } header: {
            Text("Date Range")
                .foregroundColor(themeManager.colors.secondaryText)
        }
        .listRowBackground(themeManager.colors.cardBackground)
    }
    
    private var currencySection: some View {
        Section {
            Picker("From Currency", selection: $viewModel.filterFromCurrency) {
                Text("All Currencies").tag(nil as Currency?)
                ForEach(Currency.allCases, id: \.rawValue) { currency in
                    HStack {
                        Text(currency.flag)
                        Text(currency.rawValue)
                    }
                    .tag(currency as Currency?)
                }
            }
            .foregroundColor(themeManager.colors.text)
            .accentColor(themeManager.colors.accent)
            
            Picker("To Currency", selection: $viewModel.filterToCurrency) {
                Text("All Currencies").tag(nil as Currency?)
                ForEach(Currency.allCases, id: \.rawValue) { currency in
                    HStack {
                        Text(currency.flag)
                        Text(currency.rawValue)
                    }
                    .tag(currency as Currency?)
                }
            }
            .foregroundColor(themeManager.colors.text)
            .accentColor(themeManager.colors.accent)
        } header: {
            Text("Currency Filter")
                .foregroundColor(themeManager.colors.secondaryText)
        }
        .listRowBackground(themeManager.colors.cardBackground)
    }
    
    private var amountRangeSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                Text("Minimum Amount: \(viewModel.filterMinAmount, specifier: "%.0f")")
                    .foregroundColor(themeManager.colors.text)
                
                Slider(
                    value: $viewModel.filterMinAmount,
                    in: 0...10000,
                    step: 10
                )
                .accentColor(themeManager.colors.accent)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Maximum Amount: \(viewModel.filterMaxAmount, specifier: "%.0f")")
                    .foregroundColor(themeManager.colors.text)
                
                Slider(
                    value: $viewModel.filterMaxAmount,
                    in: 0...10000,
                    step: 10
                )
                .accentColor(themeManager.colors.accent)
            }
            
            Toggle("Enable Amount Filter", isOn: $viewModel.isAmountFilterEnabled)
                .foregroundColor(themeManager.colors.text)
                .toggleStyle(SwitchToggleStyle(tint: themeManager.colors.accent))
        } header: {
            Text("Amount Range")
                .foregroundColor(themeManager.colors.secondaryText)
        }
        .listRowBackground(themeManager.colors.cardBackground)
    }
    
    private var sortingSection: some View {
        Section {
            Picker("Sort By", selection: $viewModel.sortOption) {
                Text("Date (Newest First)").tag(SortOption.dateNewest)
                Text("Date (Oldest First)").tag(SortOption.dateOldest)
                Text("Amount (Highest First)").tag(SortOption.amountHighest)
                Text("Amount (Lowest First)").tag(SortOption.amountLowest)
                Text("Currency Pair").tag(SortOption.currencyPair)
            }
            .foregroundColor(themeManager.colors.text)
            .accentColor(themeManager.colors.accent)
        } header: {
            Text("Sorting")
                .foregroundColor(themeManager.colors.secondaryText)
        }
        .listRowBackground(themeManager.colors.cardBackground)
    }
    
    private var actionsSection: some View {
        Section {
            Button(action: {
                viewModel.applyFilters()
                HapticFeedback.shared.notification(.success)
            }) {
                HStack {
                    Image(systemName: "line.3.horizontal.decrease")
                        .foregroundColor(themeManager.colors.accent)
                    
                    Text("Apply Filters")
                        .foregroundColor(themeManager.colors.text)
                    
                    Spacer()
                    
                    Text("\(viewModel.filteredHistory.count) results")
                        .font(.caption)
                        .foregroundColor(themeManager.colors.secondaryText)
                }
            }
            
            Button(action: {
                viewModel.resetFilters()
                HapticFeedback.shared.impact(.medium)
            }) {
                HStack {
                    Image(systemName: "arrow.counterclockwise")
                        .foregroundColor(themeManager.colors.warning)
                    
                    Text("Reset All Filters")
                        .foregroundColor(themeManager.colors.text)
                }
            }
        } header: {
            Text("Actions")
                .foregroundColor(themeManager.colors.secondaryText)
        }
        .listRowBackground(themeManager.colors.cardBackground)
    }
}

#Preview {
    FilterOptionsView(viewModel: HistoryViewModel())
        .environmentObject(ThemeManager.shared)
}
