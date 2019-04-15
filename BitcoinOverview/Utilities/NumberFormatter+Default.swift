import Foundation

internal extension NumberFormatter {
    static func `default`(for currency: Currency) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.currencyCode = currency.rawValue
        return formatter
    }
}
