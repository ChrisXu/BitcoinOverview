import Foundation

internal extension DateFormatter {
    
    /// This will return a default formatter for BitcoinOverview
    ///
    /// dateFormat = "MMMM d"
    ///
    /// - Returns: DateFormatter
    static func `default`() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d"
        return formatter
    }
}
