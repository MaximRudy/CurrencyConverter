import XCTest
import Combine
@testable import CurrencyConverter

@MainActor
final class CurrencyConverterViewModelTests: XCTestCase {
    private var viewModel: CurrencyConverterViewModel!
    private var mockAPIService: MockCurrencyAPIService!
    private var mockCacheService: MockCacheService!
    private var mockFavoritesService: MockFavoritesService!
    private var mockRateCalculator: MockExchangeRateCalculator!
    private var mockInputValidator: MockInputValidator!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockAPIService = MockCurrencyAPIService()
        mockCacheService = MockCacheService()
        mockFavoritesService = MockFavoritesService()
        mockRateCalculator = MockExchangeRateCalculator()
        mockInputValidator = MockInputValidator()
        cancellables = Set<AnyCancellable>()
        
        viewModel = CurrencyConverterViewModel(
            apiService: mockAPIService,
            cacheService: mockCacheService,
            favoritesService: mockFavoritesService,
            rateCalculator: mockRateCalculator,
            inputValidator: mockInputValidator,
            refreshInterval: 1.0
        )
    }
    
    override func tearDown() {
        cancellables = nil
        viewModel = nil
        super.tearDown()
    }
    
    func test_convertCurrency_withValidAmount_convertsCorrectly() {
        // Given
        mockInputValidator.parseAmountResult = 100.0
        mockRateCalculator.exchangeRate = 1.2
        viewModel.fromAmount = "100"
        
        // When
        let expectation = expectation(description: "Conversion completed")
        viewModel.$toAmount
            .dropFirst()
            .first()
            .sink { _ in expectation.fulfill() }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
        
        // Then
        XCTAssertEqual(viewModel.toAmount, "120.00")
        XCTAssertEqual(viewModel.exchangeRate, 1.2)
    }
    
    func test_convertCurrency_withInvalidAmount_resetsToZero() {
        // Given
        mockInputValidator.parseAmountResult = nil
        viewModel.fromAmount = "invalid"
        
        // When
        let expectation = expectation(description: "Conversion completed")
        viewModel.$toAmount
            .dropFirst()
            .first()
            .sink { _ in expectation.fulfill() }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
        
        // Then
        XCTAssertEqual(viewModel.toAmount, "0.00")
        XCTAssertEqual(viewModel.exchangeRate, 0.0)
    }
    
    func test_swapCurrencies_swapsCorrectly() {
        // Given
        viewModel.fromCurrency = .usd
        viewModel.toCurrency = .eur
        viewModel.fromAmount = "100"
        viewModel.toAmount = "85.50"
        mockInputValidator.isValidAmountResult = true
        
        // When
        viewModel.swapCurrencies()
        
        // Then
        XCTAssertEqual(viewModel.fromCurrency, .eur)
        XCTAssertEqual(viewModel.toCurrency, .usd)
        XCTAssertEqual(viewModel.fromAmount, "85.50")
    }
    
    func test_fetchExchangeRates_success_updatesRates() async {
        // Given
        let expectedRates = [
            ExchangeRate(fromCurrency: .usd, toCurrency: .eur, rate: 0.85, timestamp: Date()),
            ExchangeRate(fromCurrency: .usd, toCurrency: .gbp, rate: 0.75, timestamp: Date())
        ]
        mockAPIService.exchangeRatesResult = .success(expectedRates)
        mockCacheService.shouldUpdateRatesResult = true
        
        // When
        await viewModel.refreshRates()
        
        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertNotNil(viewModel.lastUpdateTime)
        XCTAssertTrue(mockCacheService.saveExchangeRatesCalled)
        XCTAssertTrue(mockRateCalculator.updateRatesCalled)
    }
    
    func test_fetchExchangeRates_failure_setsErrorMessage() async {
        // Given
        mockAPIService.exchangeRatesResult = .failure(APIError.networkError)
        mockCacheService.shouldUpdateRatesResult = true
        
        // When
        await viewModel.refreshRates()
        
        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.errorMessage)
    }
    
    func test_canSaveConversion_withValidData_returnsTrue() {
        // Given
        mockInputValidator.isValidConversionResult = true
        
        // Then
        XCTAssertTrue(viewModel.canSaveConversion)
    }
    
    func test_canSaveConversion_withInvalidData_returnsFalse() {
        // Given
        mockInputValidator.isValidConversionResult = false
        
        // Then
        XCTAssertFalse(viewModel.canSaveConversion)
    }
}
