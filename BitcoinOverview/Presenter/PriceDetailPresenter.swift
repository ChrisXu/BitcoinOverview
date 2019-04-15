//
//  PriceDetailPresenter.swift
//  BitcoinOverview
//
//  Created by Chris Xu on 2019/4/14.
//  Copyright © 2019 CXCreation. All rights reserved.
//

import Foundation

public protocol PriceDetailPresentable {
    
    /// The date that is showing for the detail
    var date: Date { get }
    
    /// A array of currencies that will be showing
    var currecies: [Currency] { get }
    
    /// It will reload the prices for the all of the currecies
    ///
    /// - Parameter completion: A callback when the operation is finished
    func reloadPrices(completion: ((Currency, Error?) -> Void)?)
    
    /// Returns the text for the rate by the given currency
    ///
    /// - Parameter curreny: the currency for the rate
    /// - Returns: A string that is formatted accordingly
    func rateTextOfPrice(for curreny: Currency) -> String?
}

open class HistoricalPriceDetailPresenter: PriceDetailPresentable {
    
    public let date: Date
    
    private(set) public var currecies = Currency.allValues
    
    fileprivate var priceMap = [Currency: Price]()
    private let backend: Backend
    fileprivate let service: PriceService
    
    init(backend: Backend, date: Date) {
        self.backend = backend
        self.service = PriceService(backend: backend)
        self.date = date
    }
    
    public func reloadPrices(completion: ((Currency, Error?) -> Void)?) {
        
        let dateRange = DateRange(start: date, end: date)
        
        currecies.forEach { currency in
            service.fetchHistoricalPrices(for: currency, dateRange: dateRange) { [weak self] result in
                
                guard let strongSelf = self else { return }
                
                do {
                    switch result {
                    case .success(let prices):
                        guard let price = prices.first else {
                            throw BackendError.notFound("No price found") // [TODO] Create custom error rather than BackendError
                        }
                        strongSelf.priceMap[currency] = price
                        completion?(currency, nil)
                    case .failure(let error):
                        throw error
                    }
                } catch {
                    completion?(currency, error)
                }
            }
        }
    }
    
    public func rateTextOfPrice(for curreny: Currency) -> String? {
        guard let price = priceMap[curreny] else {
            return nil
        }
        
        let formatter = NumberFormatter.default(for: price.currency)
        return formatter.string(from: NSNumber(value: price.rate))
    }
}


class CurrentPriceDetailPresenter: HistoricalPriceDetailPresenter {
    
    private var currentPriceUpdatingHandler: ((Currency, Error?) -> Void)?
    private var currentPriceUpdatingTimer: Timer?
    override func reloadPrices(completion: ((Currency, Error?) -> Void)?) {
        
        currentPriceUpdatingTimer?.invalidate()
        currentPriceUpdatingTimer = nil
        
        currentPriceUpdatingHandler = completion
        
        currentPriceUpdatingTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            
            guard let strongSelf = self else { return }
            
            let service = strongSelf.service
            let updatingHandler = strongSelf.currentPriceUpdatingHandler
            
            strongSelf.currecies.forEach { currency in
                service.refreshCurrentPrice(for: currency) { result in
                    
                    switch result {
                    case .success(let price):
                        strongSelf.priceMap[currency] = price
                        updatingHandler?(currency, nil)
                    case .failure(let error):
                        updatingHandler?(currency, error)
                    }
                }
            }
        }
        currentPriceUpdatingTimer?.fire()
    }
}
