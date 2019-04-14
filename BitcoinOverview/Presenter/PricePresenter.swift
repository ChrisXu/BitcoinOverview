//
//  PricePresenter.swift
//  BitcoinOverview
//
//  Created by Chris Xu on 2019/4/13.
//  Copyright © 2019 CXCreation. All rights reserved.
//

import Foundation

protocol PricePresentable {
    
    var currency: Currency { get }
    
    func reloadHistoricalPrices(completion: ((Error?) -> Void)?)
    
    func refreshPriceOfToday(completion: ((Error?) -> Void)?)
    
    func numberOfHistoricalPrices() -> Int
    
    func historicalPrice(at index: Int) -> Price
}

open class PricePresenter {
    
    private let backend: Backend
    
    init(backend: Backend) {
        self.backend = backend
    }
}
