//
//  DateRange.swift
//  BitcoinOverview
//
//  Created by Chris Xu on 2019/4/13.
//  Copyright © 2019 CXCreation. All rights reserved.
//

import Foundation

internal struct DateRange {
    
    /// default returns the range for the past 14 days
    static let `default`: DateRange = {
        
        let endDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())! 
        let startDate = Calendar.current.date(byAdding: .day, value: -14, to: Date())! // [TODO] Remove forced unwrapping
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
