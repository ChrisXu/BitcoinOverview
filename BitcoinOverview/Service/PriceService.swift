//
//  PriceService.swift
//  BitcoinOverview
//
//  Created by Chris Xu on 2019/4/13.
//  Copyright © 2019 CXCreation. All rights reserved.
//

import Foundation

final class PriceService {
    
    let backend: Backend
    
    init(backend: Backend) {
        self.backend = backend
    }
    
    /// By default, this will return the previous 14 days' worth of data for the given currency.
    ///
    /// - Parameters:
    ///   - currency: The currency to return the data in, specified in ISO 4217 format. Defaults to EUR.
    ///   - dateRange: Allows data to be returned for a specific date range
    ///   - completion: A callback with `Result`
    func fetchHistoricalPrices(for currency: Currency = .eur, dateRange: DateRange = DateRange.default, completion: @escaping (Result<[Price], BackendError>) -> Void) {
        
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "currency", value: currency.rawValue))
        
        // Must be listed as a pair of start and end parameters, with dates supplied in the yyyy-MM-dd format
        let startDate = dateRange.formattedStartDate()
        let endDate = dateRange.formattedEndDate()
        queryItems.append(URLQueryItem(name: "start", value: startDate))
        queryItems.append(URLQueryItem(name: "end", value: endDate))
        
        var request = Request(httpMethod: "GET", path: "/v1/bpi/historical/close.json")
        request.queryItems = queryItems
        
        backend.perform(request) { result in
            
            do {
                switch result {
                case .success(let data):
                    
                    let parser = HistoricalPricesParser(currency: currency)
                    let object   = try parser.parse(data: data)
                    
                    completion(Result.success(object))
                case .failure(let error):
                    throw error
                }
            } catch(let error) {
                let backendError = BackendError(error: error)
                completion(Result.failure(backendError))
            }
        }
    }
    
    
    /// This will return the current price for the given currency
    ///
    /// - Parameters:
    ///   - currency: The currency to return the data in, specified in ISO 4217 format. Defaults to EUR.
    ///   - completion: A callback with `Result`
    func refreshCurrentPrice(for currency: Currency = .eur, completion: @escaping (Result<Price, BackendError>) -> Void) {
        
        let request = Request(httpMethod: "GET", path: "/v1/bpi/currentprice/\(currency.rawValue).json")
        
        backend.perform(request) { result in
            
            do {
                switch result {
                case .success(let data):
                    
                    let parser = CurrentPriceParser(currency: currency)
                    let object = try parser.parse(data: data)
                    
                    completion(Result.success(object))
                case .failure(let error):
                    throw error
                }
            } catch(let error) {
                let backendError = BackendError(error: error)
                completion(Result.failure(backendError))
            }
        }
    }
}

enum ParserError: Error {
    case invalid(String)
    case missing(String)
}

protocol Parsing {
    
    associatedtype DataModel
    
    func parse(data: Data) throws -> DataModel
}

struct HistoricalPricesParser: Parsing {
    
    let currency: Currency
    
    init(currency: Currency) {
        self.currency = currency
    }
    
    func parse(data: Data) throws -> [Price] {
        
        let object = try JSONSerialization.jsonObject(with: data)
        
        /// Example JSON of historical prices
        /*
         {
            "bpi": {
                "2019-04-09": 5196.985,
                "2019-04-10": 5319.705,
                "2019-04-11": 5046.865,
                "2019-04-12": 5088.7483
            },
            ...
         }
        */
        guard let json = object as? [String: Any] else {
            throw ParserError.invalid("Root object is not in the correct format")
        }
        
        guard let bpiJSON = json["bpi"] as? [String: Any] else {
            throw ParserError.missing("bpi")
        }
        
        let dateFormatter = DateFormatter.coindeskFormatter()
        let prices = try bpiJSON.keys.map { key -> Price in
            
            guard let date = dateFormatter.date(from: key), let value = bpiJSON[key] as? Double else {
                throw ParserError.invalid("Cannot get valid data at \(key)")
            }
            
            return Price(rate: value, date: date, currency: currency)
        }
        
        let sortedByDate = prices.sorted(by: { $0.date.compare($1.date) == .orderedDescending })
        
        return sortedByDate
    }
}

struct CurrentPriceParser: Parsing {
    
    let currency: Currency
    
    init(currency: Currency) {
        self.currency = currency
    }
    
    func parse(data: Data) throws -> Price {
        
        let object = try JSONSerialization.jsonObject(with: data)
    
        /// Example JSON of current price
        /*
         {
            "bpi": {
                "USD": {
                    "code": "USD",
                    "rate": "5,098.8650",
                    "description": "United States Dollar",
                    "rate_float": 5098.865
                },
            },
            ...
         }
         */
        guard let json = object as? [String: Any] else {
            throw ParserError.invalid("Root object is not in the correct format")
        }
        
        guard let bpiJSON = json["bpi"] as? [String: Any] else {
            throw ParserError.missing("bpi")
        }
        
        guard let priceJSON = bpiJSON[currency.rawValue] as? [String: Any] else {
            throw ParserError.missing("\(currency.rawValue)")
        }
        
        return try Price(json: priceJSON, date: Date())
    }
}

private extension Price {
    init(json: [String: Any], date: Date) throws {
        
        guard let rate = json["rate"] as? Double else {
            throw ParserError.missing("rate")
        }
        
        guard let code = json["code"] as? String else {
            throw ParserError.missing("code")
        }
        
        guard Currency(rawValue: code) != .unsupported else {
            throw ParserError.invalid("unsupported currency code \(code)")
        }
        
        self.rate = rate
        self.currency = Currency(rawValue: code)
        self.date = date
    }
}
