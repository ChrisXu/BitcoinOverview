//
//  DateRangeTests.swift
//  BitcoinOverviewTests
//
//  Created by Chris Xu on 2019/4/13.
//  Copyright © 2019 CXCreation. All rights reserved.
//

import XCTest
@testable import BitcoinOverview

class DateRangeTests: XCTestCase {
    
    func testIfDateStringsAreFormattedCorrectly() {
        
        let expectedStartDateString = "2019-04-02"
        let expectedEndDateString = "2019-04-13"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let startDate = formatter.date(from: expectedStartDateString)!
        let endDate = formatter.date(from: expectedEndDateString)!
        
        let dateRange = DateRange(start: startDate, end: endDate)
        
        XCTAssertEqual(dateRange.formattedStartDate(), expectedStartDateString)
        XCTAssertEqual(dateRange.formattedEndDate(), expectedEndDateString)
    }
}
