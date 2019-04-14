//
//  BODateFormatter.swift
//  BitcoinOverview
//
//  Created by Chris Xu on 2019/4/13.
//  Copyright © 2019 CXCreation. All rights reserved.
//

import Foundation

internal extension DateFormatter {
    
    /// The unified DateFormatter for Coindesk.
    /// For more info, please check https://www.coindesk.com/api
    static func coindeskFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
}
