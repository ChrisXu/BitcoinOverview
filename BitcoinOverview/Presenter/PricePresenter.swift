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
    
    func refreshCurrentPrice(completion: ((Error?) -> Void)?)
    
    func numberOfHistoricalPrices() -> Int
    
    func dateTextOfHistoricalPrice(at index: Int) -> String?
    
    func rateTextOfHistoricalPrice(at index: Int) -> String?
}

open class PricePresenter: PricePresentable {
    
    var currency: Currency = .eur
    
    private let backend: Backend
    private let service: PriceService
    
    private var currentPrice: Price? = nil
    private var historicalPrices = [Price]()
    
    init(backend: Backend) {
        self.backend = backend
        self.service = PriceService(backend: backend)
    }
    
    // MARK: - PricePresentable
    
    func reloadHistoricalPrices(completion: ((Error?) -> Void)?) {
        
        service.fetchHistoricalPrices(for: currency) { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let prices):
                strongSelf.historicalPrices = prices
                completion?(nil)
            case .failure(let error):
                completion?(error)
            }
        }
    }
    
    func refreshCurrentPrice(completion: ((Error?) -> Void)?) {
        
        service.refreshCurrentPrice(for: currency) { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let price):
                strongSelf.currentPrice = price
                completion?(nil)
            case .failure(let error):
                completion?(error)
            }
        }
    }
    
    func numberOfHistoricalPrices() -> Int {
        return historicalPrices.count
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d"
        return formatter
    }()
    
    func dateTextOfHistoricalPrice(at index: Int) -> String? {
        guard let price = historicalPrice(at: index) else {
            return nil
        }
        
        return dateFormatter.string(from: price.date)
    }
    
    func rateTextOfHistoricalPrice(at index: Int) -> String? {
        guard let price = historicalPrice(at: index) else {
            return nil
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.currencyCode = price.currency.rawValue
        
        return formatter.string(from: NSNumber(value: price.rate))
    }
    
    // MARK: - Private methods
    
    private func historicalPrice(at index: Int) -> Price? {
        guard index < historicalPrices.count else {
            return nil
        }
        
        return historicalPrices[index]
    }
}
