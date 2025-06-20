import XCTest
import Combine
@testable import CurrencyConverter

@MainActor
final class SettingsViewModelTests: XCTestCase {
    
    var viewModel: SettingsViewModel!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        viewModel = SettingsViewModel()
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        cancellables = nil
        viewModel = nil
        super.tearDown()
    }

    func testAutoRefreshIntervalChange() {
        let newInterval: Double = 600
        viewModel.autoRefreshInterval = newInterval
        XCTAssertEqual(viewModel.autoRefreshInterval, newInterval)
        XCTAssertEqual(UserDefaults.standard.double(forKey: "autoRefreshInterval"), newInterval)
    }
    
    func testHapticFeedbackEnabledChange() {
        // Given
        let newValue = false
        
        // When
        viewModel.hapticFeedbackEnabled = newValue
        
        // Then
        XCTAssertEqual(viewModel.hapticFeedbackEnabled, newValue)
        XCTAssertEqual(UserDefaults.standard.bool(forKey: "hapticFeedbackEnabled"), newValue)
    }
    
    func testShowRateChangesChange() {
        // Given
        let newValue = false
        
        // When
        viewModel.showRateChanges = newValue
        
        // Then
        XCTAssertEqual(viewModel.showRateChanges, newValue)
        XCTAssertEqual(UserDefaults.standard.bool(forKey: "showRateChanges"), newValue)
    }
    
    func testDefaultFromCurrencyChange() {
        // Given
        let newCurrency = Currency.eur.rawValue
        
        // When
        viewModel.defaultFromCurrency = newCurrency
        
        // Then
        XCTAssertEqual(viewModel.defaultFromCurrency, newCurrency)
        XCTAssertEqual(UserDefaults.standard.string(forKey: "defaultFromCurrency"), newCurrency)
    }
    
    func testDefaultToCurrencyChange() {
        // Given
        let newCurrency = Currency.gbp.rawValue
        
        // When
        viewModel.defaultToCurrency = newCurrency
        
        // Then
        XCTAssertEqual(viewModel.defaultToCurrency, newCurrency)
        XCTAssertEqual(UserDefaults.standard.string(forKey: "defaultToCurrency"), newCurrency)
    }
    
    func testShowingThemeSelectorPublished() {
        let expectation = XCTestExpectation(description: "showingThemeSelector should publish changes")
        
        viewModel.$showingThemeSelector
            .dropFirst()
            .sink { value in
                XCTAssertTrue(value)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.showingThemeSelector = true
        
        wait(for: [expectation], timeout: 1.0)
    }
}
