//
//  Price.swift
//  BitcoinOverview
//
//  Created by Chris Xu on 2019/4/13.
//  Copyright © 2019 CXCreation. All rights reserved.
//

import Foundation

struct Price: Equatable {
    
    let rate: Double
    
    let date: Date
        
    let currency: Currency
    
    init(rate: Double, date: Date, currency: Currency) {
        self.rate = rate
        self.date = date
        self.currency = currency
    }
    
    public static func == (lhs: Price, rhs: Price) -> Bool {
        return (lhs.rate == rhs.rate) && (lhs.date == rhs.date) && (lhs.currency == rhs.currency)
    }
}
