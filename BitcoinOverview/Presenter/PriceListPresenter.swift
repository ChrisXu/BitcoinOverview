//
//  PricePresenter.swift
//  BitcoinOverview
//
//  Created by Chris Xu on 2019/4/13.
//  Copyright © 2019 CXCreation. All rights reserved.
//

import Foundation

public protocol PriceListPresentable {
    
    /// The currency that will be using for requests
    var currency: Currency { get }
    
    /// This will reload the historical prices
    ///
    /// - Parameter completion: callback when it's finished
    /// - Returns: the error if the operation can not be completed
    func reloadHistoricalPrices(completion: ((Error?) -> Void)?)
    
    /// This will refresh and schedule updating current price periodically
    ///
    /// - Parameters:
    ///   - interval: the number of seconds between updatings of the current price
    ///   - updatingHandler: the handler that will be called repeatedly
    /// - Returns: the error if the operation can not be completed
    func scheduleUpdatingCurrentPrice(withTimeInterval interval: TimeInterval, updatingHandler: ((Error?) -> Void)?)
    
    /// Returns a number of historical prices
    ///
    /// - Returns: A integer
    func numberOfHistoricalPrices() -> Int
    
    /// Returns the text for the date by the given index
    ///
    /// - Parameter index: An index of the historical price
    /// - Returns: A string that is formatted accordingly
    func dateTextOfHistoricalPrice(at index: Int) -> String?
    
    /// Returns the text for the rate by the given index
    ///
    /// - Parameter index: An index of the historical price
    /// - Returns: A string that is formatted accordingly
    func rateTextOfHistoricalPrice(at index: Int) -> String?
    
    /// Returns the latest text for the current price
    ///
    /// - Returns: A string that is formatted accordingly
    func textForCurrentPrice() -> String?
    
    /// Returns a presenter that conforms to `PriceDetailPresentable` by the given index
    ///
    /// If index is not provided, it will return the presenter for the detail of the current price.
    /// Otherwise, it will return the presenter for the detail of the historical price
    /// - Parameter index: An index of the historical price
    /// - Returns: A presenter
    func presenterForDetail(at index: Int?) -> PriceDetailPresentable?
}

open class PriceListPresenter: PriceListPresentable {
    
    public var currency: Currency = .eur
    
    private let backend: Backend
    private let service: PriceService
    
    private var currentPrice: Price? = nil
    private var historicalPrices = [Price]()
    
    init(backend: Backend) {
        self.backend = backend
        self.service = PriceService(backend: backend)
    }
    
    // MARK: - PriceListPresentable
    
    public func reloadHistoricalPrices(completion: ((Error?) -> Void)?) {
        
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
    
    private var currentPriceUpdatingHandler: ((Error?) -> Void)?
    private var currentPriceUpdatingTimer: Timer?
    public func scheduleUpdatingCurrentPrice(withTimeInterval interval: TimeInterval = 60, updatingHandler: ((Error?) -> Void)?) {
        
        currentPriceUpdatingTimer?.invalidate()
        currentPriceUpdatingTimer = nil
        
        currentPriceUpdatingHandler = updatingHandler
        
        currentPriceUpdatingTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            
            guard let strongSelf = self else { return }
            
            let service = strongSelf.service
            let currency = strongSelf.currency
            let updatingHandler = strongSelf.currentPriceUpdatingHandler
            
            service.refreshCurrentPrice(for: currency) { result in
                
                switch result {
                case .success(let price):
                    strongSelf.currentPrice = price
                    updatingHandler?(nil)
                case .failure(let error):
                    updatingHandler?(error)
                }
            }
        }
        currentPriceUpdatingTimer?.fire()
    }
    
    public func numberOfHistoricalPrices() -> Int {
        return historicalPrices.count
    }
    
    private let dateFormatter = DateFormatter.default() // Avoid creating duplicated instances
    
    public func dateTextOfHistoricalPrice(at index: Int) -> String? {
        guard let price = historicalPrice(at: index) else {
            return nil
        }
        
        return dateFormatter.string(from: price.date)
    }
    
    public func rateTextOfHistoricalPrice(at index: Int) -> String? {
        guard let price = historicalPrice(at: index) else {
            return nil
        }
        
        let formatter = NumberFormatter.default(for: price.currency)
        return formatter.string(from: NSNumber(value: price.rate))
    }
    
    public func textForCurrentPrice() -> String? {
        guard let price = currentPrice else {
            return nil
        }
        
        let formatter = NumberFormatter.default(for: price.currency)
        return formatter.string(from: NSNumber(value: price.rate))
    }
    
    public func presenterForDetail(at index: Int?) -> PriceDetailPresentable? {
        
        if let index = index {
            guard let price = historicalPrice(at: index) else {
                return nil
            }
            return HistoricalPriceDetailPresenter(backend: backend, date: price.date)
        } else {
            guard let price = currentPrice else {
                return nil
            }
            return CurrentPriceDetailPresenter(backend: backend, date: price.date)
        }
    }
    
    // MARK: - Private methods
    
    private func historicalPrice(at index: Int) -> Price? {
        guard index < historicalPrices.count else {
            return nil
        }
        
        return historicalPrices[index]
    }
}
