# Currency Converter iOS App

Currency converter app for iOS built with SwiftUI, featuring real-time exchange rates, conversion history.

## Features

### Core Functionality
- **Real-time Exchange Rates**: Get up-to-date currency exchange rates from multiple reliable sources
- **6 Currencies**: Support for major world currencies with automatic updates
- **Quick Conversion**: Fast and accurate currency conversion with intuitive interface
- **Offline Mode**: Access last known rates when offline

### Setup
1. Clone the repository:
```bash
git clone https://github.com/yourusername/currency-converter-ios.git
cd currency-converter-ios
```

2. Open the project in Xcode:
```bash
open CurrencyConverter.xcodeproj
```

3. Configure your development team:
   - Select the project in Xcode
   - Go to "Signing & Capabilities"
   - Select your development team

4. Build and run:
   - Select your target device/simulator
   - Press `Cmd + R` to build and run

### API Configuration
The app uses multiple exchange rate APIs for redundancy. Configure your API keys in `CurrencyAPIService.swift`:

private let apiKey = "YOUR_API_KEY"
