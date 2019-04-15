//
//  PriceServiceTests.swift
//  BitcoinOverviewTests
//
//  Created by Chris Xu on 2019/4/13.
//  Copyright © 2019 CXCreation. All rights reserved.
//

import XCTest
@testable import BitcoinOverview

class PriceServiceTests: XCTestCase {
    
    private var mockedBackend: MockBackend!
    private var service: PriceService!
    
    override func setUp() {
        super.setUp()
        
        mockedBackend = MockBackend()
        service = PriceService(backend: mockedBackend)
    }
    
    func testIfServiceCanFetchHistoricalPrices() {
        
        let expect = expectation(description: #function)
        
        let expectedFirstRate = 5196.985
        let expectedLastRate = 5196.985
        
        mockedBackend.requestInterceptor = { _ in
            let jsonString = """
                {
                    "bpi": {
                        "2019-04-09": \(expectedLastRate),
                        "2019-04-10": 5319.705,
                        "2019-04-11": 5046.865,
                        "2019-04-12": \(expectedFirstRate)
                    }
                }
            """
            return jsonString.data(using: .utf8)
        }
        
        service.fetchHistoricalPrices { result in
            switch result {
            case .success(let prices):
                XCTAssertEqual(4, prices.count)
                XCTAssertEqual(prices.first?.rate, expectedFirstRate)
                XCTAssertEqual(prices.last?.rate, expectedLastRate)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testIfServiceCanRefreshCurrentPrice() {
        
        let expect = expectation(description: #function)
        
        let expectedPrice = Price(rate: 5098.865, date: Date(), currency: .usd)
        
        mockedBackend.requestInterceptor = { _ in
            let jsonString = """
            {
                "bpi": {
                    "\(expectedPrice.currency.rawValue)": {
                        "code": "\(expectedPrice.currency.rawValue)",
                        "rate": "5,098.8650",
                        "description": "United States Dollar",
                        "rate_float": \(expectedPrice.rate)
                    }
                }
            }
            """
            return jsonString.data(using: .utf8)
        }
        
        service.refreshCurrentPrice(for: expectedPrice.currency) { result in
            switch result {
            case .success(let price):
                XCTAssertEqual(price.rate, expectedPrice.rate)
                XCTAssertEqual(price.currency, expectedPrice.currency)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
}
