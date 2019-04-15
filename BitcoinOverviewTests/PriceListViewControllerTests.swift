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
    }
}
