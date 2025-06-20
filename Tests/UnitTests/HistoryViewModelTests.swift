import XCTest
import Combine
@testable import CurrencyConverter

class HistoryViewModelTests: XCTestCase {
    
    private var viewModel: HistoryViewModel!
    private var mockUserDefaults: MockUserDefaults!
    private var mockHapticFeedback: MockHapticFeedback!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockUserDefaults = MockUserDefaults()
        mockHapticFeedback = MockHapticFeedback()
        viewModel = HistoryViewModel(
            userDefaults: mockUserDefaults,
            hapticFeedback: mockHapticFeedback
        )
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        viewModel = nil
        mockUserDefaults = nil
        mockHapticFeedback = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testAddRecord() {
        // Given
        let record = createMockRecord()
        
        // When
        viewModel.addRecord(record)
        
        // Then
        XCTAssertEqual(viewModel.conversionHistory.count, 1)
        XCTAssertEqual(viewModel.conversionHistory.first?.id, record.id)
        XCTAssertEqual(viewModel.filteredHistory.count, 1)
        XCTAssertTrue(mockUserDefaults.setDataCalled)
    }
    
    func testDeleteRecord() {
        // Given
        let record = createMockRecord()
        viewModel.addRecord(record)
        
        // When
        viewModel.deleteRecord(record)
        
        // Then
        XCTAssertTrue(viewModel.conversionHistory.isEmpty)
        XCTAssertTrue(viewModel.filteredHistory.isEmpty)
        XCTAssertTrue(mockHapticFeedback.notificationCalled)
        XCTAssertEqual(mockHapticFeedback.lastNotificationType, .success)
    }
    
    func testLoadHistoryWithValidData() {
        // Given
        let records = [createMockRecord(), createMockRecord()]
        let data = try! JSONEncoder().encode(records)
        mockUserDefaults.mockData["conversionHistory"] = data
        
        // When
        viewModel.loadHistory()
        
        // Then
        XCTAssertEqual(viewModel.conversionHistory.count, 2)
        XCTAssertEqual(viewModel.filteredHistory.count, 2)
    }
    
    func testLoadHistoryWithInvalidData() {
        // Given
        mockUserDefaults.mockData["conversionHistory"] = Data("invalid".utf8)
        
        // When
        viewModel.loadHistory()
        
        // Then
        XCTAssertTrue(viewModel.conversionHistory.isEmpty)
        XCTAssertTrue(viewModel.filteredHistory.isEmpty)
    }
    
    func testSearchFilter() {
        // Given
        let usdRecord = createMockRecord(fromCurrency: .usd, toCurrency: .eur)
        let rubRecord = createMockRecord(fromCurrency: .rub, toCurrency: .gbp)
        viewModel.addRecord(usdRecord)
        viewModel.addRecord(rubRecord)
        
        // When
        viewModel.searchText = "USD"
        
        // Then
        XCTAssertEqual(viewModel.filteredHistory.count, 1)
        XCTAssertEqual(viewModel.filteredHistory.first?.fromCurrency, .usd)
    }
    
    func testCurrencyFilter() {
        // Given
        let usdRecord = createMockRecord(fromCurrency: .usd, toCurrency: .eur)
        let rubRecord = createMockRecord(fromCurrency: .rub, toCurrency: .gbp)
        viewModel.addRecord(usdRecord)
        viewModel.addRecord(rubRecord)
        
        // When
        viewModel.filterFromCurrency = .usd
        
        // Then
        XCTAssertEqual(viewModel.filteredHistory.count, 1)
        XCTAssertEqual(viewModel.filteredHistory.first?.fromCurrency, .usd)
    }
    
    func testAmountFilter() {
        // Given
        let lowRecord = createMockRecord(fromAmount: 50.0)
        let highRecord = createMockRecord(fromAmount: 500.0)
        viewModel.addRecord(lowRecord)
        viewModel.addRecord(highRecord)
        
        // When
        viewModel.filterMinAmount = 100.0
        viewModel.filterMaxAmount = 1000.0
        viewModel.isAmountFilterEnabled = true
        
        // Then
        XCTAssertEqual(viewModel.filteredHistory.count, 1)
        XCTAssertEqual(viewModel.filteredHistory.first?.fromAmount, 500.0)
    }
    
    func testCombinedFilters() {
        // Given
        let targetRecord = createMockRecord(
            fromCurrency: .usd,
            toCurrency: .eur,
            fromAmount: 100.0
        )
        let otherRecord = createMockRecord(
            fromCurrency: .rub,
            toCurrency: .gbp,
            fromAmount: 50.0
        )
        
        viewModel.addRecord(targetRecord)
        viewModel.addRecord(otherRecord)
        
        // When
        viewModel.searchText = "USD"
        viewModel.filterMinAmount = 80.0
        viewModel.isAmountFilterEnabled = true
        
        // Then
        XCTAssertEqual(viewModel.filteredHistory.count, 1)
        XCTAssertEqual(viewModel.filteredHistory.first?.id, targetRecord.id)
    }
    
    func testToggleFavorite() {
        // Given
        let record = createMockRecord()
        viewModel.addRecord(record)
        
        // When
        viewModel.toggleFavorite(record)
        
        // Then
        XCTAssertTrue(viewModel.isFavorite(record))
        XCTAssertTrue(mockHapticFeedback.impactCalled)
        XCTAssertEqual(mockHapticFeedback.lastImpactStyle, .light)
        
        // When - toggle again
        viewModel.toggleFavorite(record)
        
        // Then
        XCTAssertFalse(viewModel.isFavorite(record))
    }
    
    func testFavoritesPersistence() {
        // Given
        let record = createMockRecord()
        viewModel.addRecord(record)
        viewModel.toggleFavorite(record)
        
        // When - create new view model instance
        let newViewModel = HistoryViewModel(
            userDefaults: mockUserDefaults,
            hapticFeedback: mockHapticFeedback
        )
        
        // Then
        XCTAssertTrue(newViewModel.isFavorite(record))
    }
    
    func testResetFilters() {
        // Given
        viewModel.searchText = "USD"
        viewModel.isDateFilterEnabled = true
        viewModel.filterFromCurrency = .usd
        viewModel.isAmountFilterEnabled = true
        viewModel.sortOption = .amountHighest
        
        // When
        viewModel.resetFilters()
        
        // Then
        XCTAssertEqual(viewModel.searchText, "")
        XCTAssertFalse(viewModel.isDateFilterEnabled)
        XCTAssertNil(viewModel.filterFromCurrency)
        XCTAssertFalse(viewModel.isAmountFilterEnabled)
        XCTAssertEqual(viewModel.sortOption, .dateNewest)
    }
    
    func testClearAllHistory() {
        // Given
        let record = createMockRecord()
        viewModel.addRecord(record)
        viewModel.toggleFavorite(record)
        
        // When
        viewModel.clearAllHistory()
        
        // Then
        XCTAssertTrue(viewModel.conversionHistory.isEmpty)
        XCTAssertTrue(viewModel.filteredHistory.isEmpty)
        XCTAssertFalse(viewModel.isFavorite(record))
        XCTAssertTrue(mockHapticFeedback.notificationCalled)
        XCTAssertEqual(mockHapticFeedback.lastNotificationType, .warning)
    }
    
    func testSearchTextTriggersFilter() {
        // Given
        let expectation = XCTestExpectation(description: "Filter applied")
        var filterCallCount = 0
        
        viewModel.$filteredHistory
            .dropFirst()
            .sink { _ in
                filterCallCount += 1
                if filterCallCount == 1 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        viewModel.searchText = "USD"
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(filterCallCount, 1)
    }
}

extension HistoryViewModelTests {
    private func createMockRecord(
        fromCurrency: Currency = .usd,
        toCurrency: Currency = .eur,
        fromAmount: Double = 100.0,
        toAmount: Double = 85.0
    ) -> ConversionRecord {
        ConversionRecord(
            fromCurrency: fromCurrency,
            toCurrency: toCurrency,
            fromAmount: fromAmount,
            toAmount: toAmount,
            rate: toAmount / fromAmount
        )
    }
}
