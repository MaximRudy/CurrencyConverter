import SwiftUI

struct ExportOptionsView: View {
    let history: [ConversionRecord]
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedFormat: ExportFormat = .csv
    @State private var showingShareSheet = false
    @State private var exportURL: URL?
    
    var body: some View {
        NavigationView {
            ZStack {
                themeManager.colors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    headerSection
                    formatSelection
                    previewSection
                    exportButton
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Export History")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                    .foregroundColor(themeManager.colors.accent)
            )
        }
        .sheet(isPresented: $showingShareSheet) {
            if let url = exportURL {
                ShareSheet(activityItems: [url])
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "square.and.arrow.up.circle.fill")
                .font(.system(size: 50))
                .foregroundColor(themeManager.colors.accent)
            
            Text("Export Conversion History")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(themeManager.colors.text)
            
            Text("\(history.count) conversions ready to export")
                .font(.subheadline)
                .foregroundColor(themeManager.colors.secondaryText)
        }
    }
    
    private var formatSelection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Choose Format")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(themeManager.colors.text)
            
            ForEach(ExportFormat.allCases, id: \.rawValue) { format in
                FormatOptionRow(
                    format: format,
                    isSelected: selectedFormat == format
                ) {
                    selectedFormat = format
                    HapticFeedback.shared.impact(.light)
                }
            }
        }
    }
    
    private var previewSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Preview")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(themeManager.colors.text)
            
            ScrollView {
                Text(generatePreview())
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(themeManager.colors.secondaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(themeManager.colors.cardBackground)
                    )
            }
            .frame(maxHeight: 150)
        }
    }
    
    private var exportButton: some View {
        Button(action: exportData) {
            HStack {
                Image(systemName: "square.and.arrow.up")
                Text("Export \(selectedFormat.rawValue)")
            }
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundColor(themeManager.colors.background)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(themeManager.colors.accent)
            )
        }
        .disabled(history.isEmpty)
    }
    
    private func generatePreview() -> String {
        let sampleRecords = Array(history.prefix(3))
        
        switch selectedFormat {
        case .csv:
            var csv = "Date,From Currency,To Currency,From Amount,To Amount,Exchange Rate\n"
            for record in sampleRecords {
                csv += "\(record.timestamp),\(record.fromCurrency.rawValue),\(record.toCurrency.rawValue),\(record.fromAmount),\(record.toAmount),\(record.rate)\n"
            }
            return csv + (history.count > 3 ? "..." : "")
            
        case .json:
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            encoder.outputFormatting = .prettyPrinted
            
            if let data = try? encoder.encode(sampleRecords),
               let jsonString = String(data: data, encoding: .utf8) {
                return jsonString + (history.count > 3 ? "\n..." : "")
            }
            return "Error generating preview"
            
        case .txt:
            var text = "Currency Conversion History\n"
            text += "Generated: \(Date())\n\n"
            
            for record in sampleRecords {
                text += "Date: \(record.timestamp)\n"
                text += "Conversion: \(record.fromAmount) \(record.fromCurrency.rawValue) → \(record.toAmount) \(record.toCurrency.rawValue)\n"
                text += "Rate: \(record.rate)\n\n"
            }
            
            return text + (history.count > 3 ? "..." : "")
        }
    }
    
    private func exportData() {
        let fileName = "currency_history_\(Date().timeIntervalSince1970)"
        let fileExtension: String
        let content: String
        
        switch selectedFormat {
        case .csv:
            fileExtension = "csv"
            content = generateCSV()
        case .json:
            fileExtension = "json"
            content = generateJSON()
        case .txt:
            fileExtension = "txt"
            content = generateText()
        }
        
        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("\(fileName).\(fileExtension)")
        
        do {
            try content.write(to: tempURL, atomically: true, encoding: .utf8)
            exportURL = tempURL
            showingShareSheet = true
            HapticFeedback.shared.notification(.success)
        } catch {
            print("Export error: \(error)")
            HapticFeedback.shared.notification(.error)
        }
    }
    
    private func generateCSV() -> String {
        var csv = "Date,From Currency,To Currency,From Amount,To Amount,Exchange Rate\n"
        
        for record in history {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            
            csv += "\(dateFormatter.string(from: record.timestamp)),"
            csv += "\(record.fromCurrency.rawValue),"
            csv += "\(record.toCurrency.rawValue),"
            csv += "\(record.fromAmount),"
            csv += "\(record.toAmount),"
            csv += "\(record.rate)\n"
        }
        
        return csv
    }
    
    private func generateJSON() -> String {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let data = try encoder.encode(history)
            return String(data: data, encoding: .utf8) ?? "Error encoding JSON"
        } catch {
            return "Error generating JSON: \(error)"
        }
    }
    
    private func generateText() -> String {
        var text = "Currency Conversion History\n"
        text += "Generated: \(Date())\n"
        text += "Total Conversions: \(history.count)\n\n"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        for record in history {
            text += "Date: \(dateFormatter.string(from: record.timestamp))\n"
            text += "Conversion: \(record.fromAmount) \(record.fromCurrency.rawValue) → \(record.toAmount) \(record.toCurrency.rawValue)\n"
            text += "Exchange Rate: \(record.rate)\n"
            text += "---\n\n"
        }
        
        return text
    }
}

struct FormatOptionRow: View {
    let format: ExportFormat
    let isSelected: Bool
    let onTap: () -> Void
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Image(systemName: format.icon)
                    .font(.title3)
                    .foregroundColor(themeManager.colors.accent)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(format.rawValue)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(themeManager.colors.text)
                    
                    Text(format.description)
                        .font(.caption)
                        .foregroundColor(themeManager.colors.secondaryText)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(themeManager.colors.accent)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(themeManager.colors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                isSelected ? themeManager.colors.accent : themeManager.colors.secondary.opacity(0.3),
                                lineWidth: isSelected ? 2 : 1
                            )
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    ExportOptionsView(history: [])
        .environmentObject(ThemeManager.shared)
}
