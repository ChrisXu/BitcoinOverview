//
//  PriceDetailPresenter.swift
//  BitcoinOverview
//
//  Created by Chris Xu on 2019/4/14.
//  Copyright © 2019 CXCreation. All rights reserved.
//

import Foundation

public protocol PriceDetailPresentable {
    
    var date: Date { get }
    
    var currecies: [Currency] { get }
    
    func reloadPrices(completion: ((Currency, Error?) -> Void)?)
    
    func rateTextOfPrice(for curreny: Currency) -> String?
}

open class HistoricalPriceDetailPresenter: PriceDetailPresentable {
    
    public let date: Date
    
    private(set) public var currecies = Currency.allValues
    
    private var priceMap = [Currency: Price]()
    private let backend: Backend
    private let service: PriceService
    
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
