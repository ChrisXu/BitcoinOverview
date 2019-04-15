//
//  NumberFormatter+Shared.swift
//  BitcoinOverview
//
//  Created by Chris Xu on 2019/4/14.
//  Copyright © 2019 CXCreation. All rights reserved.
//

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
