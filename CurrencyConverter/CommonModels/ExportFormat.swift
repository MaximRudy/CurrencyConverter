import Foundation

enum ExportFormat: String, CaseIterable {
    case csv = "CSV"
    case json = "JSON"
    case txt = "Text"
    
    var icon: String {
        switch self {
        case .csv: return "tablecells"
        case .json: return "curlybraces"
        case .txt: return "doc.text"
        }
    }
    
    var description: String {
        switch self {
        case .csv: return "Spreadsheet compatible format"
        case .json: return "Structured data format"
        case .txt: return "Plain text format"
        }
    }
}
