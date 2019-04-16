//
//  PriceListViewControllerTests.swift
//  BitcoinOverviewTests
//
//  Created by Chris Xu on 2019/4/15.
//  Copyright © 2019 CXCreation. All rights reserved.
//

import XCTest
@testable import BitcoinOverview


/// UITesting is expensive in terms of time and resource.
/// This demostrates how some tests of UI can be done in Unit-test as well
class PriceListViewControllerTests: XCTestCase {

    private var mockedBackend: MockBackend!
    private var presenter: PriceListPresenter!
    private var viewController: PriceListViewController!
    
    override func setUp() {
        mockedBackend = MockBackend()
        presenter = PriceListPresenter(backend: mockedBackend)
        viewController = PriceListViewController(presenter: presenter)
        
        viewController.viewDidLoad() // Initialize the UI
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
        let collectionView = viewController.collectionView
        XCTAssertEqual(collectionView?.numberOfItems(inSection: 0), 6)
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
}
