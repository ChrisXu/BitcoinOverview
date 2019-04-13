//
//  Price.swift
//  BitcoinOverview
//
//  Created by Chris Xu on 2019/4/13.
//  Copyright © 2019 CXCreation. All rights reserved.
//

import Foundation

/// Current supported currencies
enum Currency: String, Codable {
    
    case EUR
    case USD
    case GBP
}

struct Price: Codable { 
    
    let price: Double
    
    let updatedTimeInterval: TimeInterval
    
    let currency: Currency
}
