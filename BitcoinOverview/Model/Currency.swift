//
//  Currency.swift
//  BitcoinOverview
//
//  Created by Chris Xu on 2019/4/15.
//  Copyright © 2019 CXCreation. All rights reserved.
//

import Foundation

/// Current supported currencies
public enum Currency: String, Equatable {
    
    case eur = "EUR"
    case usd = "USD"
    case gbp = "GBP"
    case unsupported
    
    static let allValues: [Currency] = [.eur, .usd, .gbp]
    
    public init(rawValue: String) {
        switch rawValue {
        case Currency.eur.rawValue: self = .eur
        case Currency.usd.rawValue: self = .usd
        case Currency.gbp.rawValue: self = .gbp
        default: self = .unsupported
        }
    }
}
