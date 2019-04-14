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
        
        service.fetchHistoricalPrices { result in
            
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testIfServiceCanRefreshCurrentPrice() {
        
        let expect = expectation(description: #function)
        
        service.refreshCurrentPrice { result in
            
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
}
