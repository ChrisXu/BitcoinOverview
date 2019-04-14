//
//  Price.swift
//  BitcoinOverview
//
//  Created by Chris Xu on 2019/4/13.
//  Copyright © 2019 CXCreation. All rights reserved.
//

import Foundation

/// Current supported currencies
enum Currency: String {
    
    case eur = "EUR"
    case usd = "USD"
    case gbp = "GBP"
    case unsupported
    
    static let allValues: [Currency] = [.eur, .usd, .gbp]
    
    init(rawValue: String) {
        switch rawValue {
        case Currency.eur.rawValue: self = .eur
        case Currency.usd.rawValue: self = .usd
        case Currency.gbp.rawValue: self = .gbp
        default: self = .unsupported
        }
    }
}

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
