//
//  PriceListPresenterTests.swift
//  BitcoinOverviewTests
//
//  Created by Chris Xu on 2019/4/15.
//  Copyright © 2019 CXCreation. All rights reserved.
//

import XCTest
@testable import BitcoinOverview

class PriceListPresenterTests: XCTestCase {

    private var mockedBackend: MockBackend!
    private var presenter: PriceListPresenter!
    
    override func setUp() {
        mockedBackend = MockBackend()
        presenter = PriceListPresenter(backend: mockedBackend)
    }

    override func tearDown() {
        presenter = nil
    }
    
    func testIfNumberOfHistoricalPricesIsCorrect() {
        // Given
        mockedBackend.requestInterceptor = { _ in
            let jsonString = """
            {
                "bpi": {
                    "2019-04-09": 5196.985,
                    "2019-04-10": 5319.705,
                    "2019-04-11": 5046.865,
                    "2019-04-12": 5196.985,
                    "2019-04-13": 5186.321,
                    "2019-04-14": 5216.123
                }
            }
            """
            return jsonString.data(using: .utf8)
        }
        // When
        reloadingHistoricalPrices()
        // Then
        XCTAssertEqual(presenter.numberOfHistoricalPrices(), 6)
    }
    
    func testIfDateTextOfHistoricalPriceIsCorrect() {
        // Given
        mockedBackend.requestInterceptor = { _ in
            let jsonString = """
            {
                "bpi": {
                    "2019-04-09": 5196.985,
                    "2019-04-10": 5319.705,
                    "2019-04-11": 5046.865,
                    "2019-04-12": 5196.985,
                    "2019-04-13": 5186.321,
                    "2019-04-14": 5216.123
                }
            }
            """
            return jsonString.data(using: .utf8)
        }
        // When
        reloadingHistoricalPrices()
        // Then
        XCTAssertNotNil(presenter.dateTextOfHistoricalPrice(at: 0))
        XCTAssertEqual(presenter.dateTextOfHistoricalPrice(at: 0), "April 14")
        
        XCTAssertNotNil(presenter.dateTextOfHistoricalPrice(at: 5))
        XCTAssertEqual(presenter.dateTextOfHistoricalPrice(at: 5), "April 9")
    }
    
    func testIfRateTextOfHistoricalPrice() {
        // Given
        let currency = presenter.currency
        let expectedRate: Double = 5186.321
        let expectedText = NumberFormatter.default(for: currency).string(from: NSNumber(value: expectedRate))
        mockedBackend.requestInterceptor = { _ in
            let jsonString = """
            {
                "bpi": {
                    "2019-04-09": 5196.985,
                    "2019-04-10": 5319.705,
                    "2019-04-11": 5046.865,
                    "2019-04-12": 5196.985,
                    "2019-04-13": \(expectedRate),
                    "2019-04-14": 5216.123
                }
            }
            """
            return jsonString.data(using: .utf8)
        }
        // When
        reloadingHistoricalPrices()
        // Then
        XCTAssertNotNil(presenter.rateTextOfHistoricalPrice(at: 1))
        XCTAssertEqual(presenter.rateTextOfHistoricalPrice(at: 1), expectedText)
    }
    
    func testIfCurrentWillUpdatePeriodically() {
        // Given
        let currency = presenter.currency
        let formatter = NumberFormatter.default(for: currency)
        
        func setMockedRate(to rate: Double) {
            mockedBackend.requestInterceptor = { _ in
                let jsonString = """
                {
                "bpi": {
                "EUR": {
                "code": "EUR",
                "description": "United States Dollar",
                "rate_float": \(rate)
                }
                }
                }
                """
                return jsonString.data(using: .utf8)
            }
        }
        // Given
        setMockedRate(to: 1.01)
        // When
        reloadCurrentPrice { [weak self] (times, expect) in
            guard let strongSelf = self else { return }
            guard let presenter = strongSelf.presenter else { return }
            // Then
            XCTAssertNotNil(presenter.textForCurrentPrice())
            switch times {
            case 1:
                XCTAssertEqual(presenter.textForCurrentPrice(), formatter.string(from: NSNumber(value: 1.01)))
                setMockedRate(to: 512.314) // Update the mocked rate to new value
                break
            case 2:
                XCTAssertEqual(presenter.textForCurrentPrice(), formatter.string(from: NSNumber(value: 512.314)))
                expect.fulfill()
                break
            default:
                XCTFail()
            }
        }
    }
    
    // MARK: - Private method
    
    private func reloadingHistoricalPrices() {
        let expect = expectation(description: #function)
        
        presenter.reloadHistoricalPrices { error in
            XCTAssertNil(error)
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    private func reloadCurrentPrice(block: @escaping (Int, XCTestExpectation) -> Void) {
        let expect = expectation(description: #function)
        
        var times = 0
        presenter.scheduleUpdatingCurrentPrice(withTimeInterval: 2) { error in
            XCTAssertNil(error)
            times += 1
            block(times, expect)
        }
        
        waitForExpectations(timeout: 4)
    }
}
