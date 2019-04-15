//
//  HistoricalPriceDetailPresenter.swift
//  BitcoinOverviewTests
//
//  Created by Chris Xu on 2019/4/15.
//  Copyright © 2019 CXCreation. All rights reserved.
//

import XCTest
@testable import BitcoinOverview

class HistoricalPriceDetailPresenterTests: XCTestCase {
    
    private var mockedBackend: MockBackend!
    private var presenter: HistoricalPriceDetailPresenter!
    private var date = Date()
    
    override func setUp() {
        mockedBackend = MockBackend()
        presenter = HistoricalPriceDetailPresenter(backend: mockedBackend, date: date)
    }
}
