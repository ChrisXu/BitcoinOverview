//
//  Price.swift
//  BitcoinOverview
//
//  Created by Chris Xu on 2019/4/13.
//  Copyright © 2019 CXCreation. All rights reserved.
//

import Foundation

struct Price { 
    
    let rate: Double
    
    let date: Date
        
    let currency: Currency
    
    init(rate: Double, date: Date, currency: Currency) {
        self.rate = rate
        self.date = date
        self.currency = currency
    }
}
