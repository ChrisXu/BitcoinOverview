//
//  DateRange.swift
//  BitcoinOverview
//
//  Created by Chris Xu on 2019/4/13.
//  Copyright © 2019 CXCreation. All rights reserved.
//

import Foundation

struct DateRange {
    
    /// default returns the range between today and 14 days before
    static let `default`: DateRange = {
        
        let endDate = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -14, to: endDate)! // [TODO] Remove forced unwrapping
        return DateRange(start: startDate, end: endDate)
    }()
    
    let start: Date
    let end: Date
    
    private let dateFormatter = DateFormatter.coindeskFormatter()
    
    init(start: Date, end: Date = Date()) {
        self.start = start
        self.end = end
    }
    
    func formattedStartDate() -> String {
        return self.dateFormatter.string(from: start)
    }
    
    func formattedEndDate() -> String {
        return self.dateFormatter.string(from: end)
    }
}
