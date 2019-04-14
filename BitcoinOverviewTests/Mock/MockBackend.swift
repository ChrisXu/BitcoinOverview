//
//  MockBackend.swift
//  BitcoinOverviewTests
//
//  Created by Chris Xu on 2019/4/13.
//  Copyright © 2019 CXCreation. All rights reserved.
//

import Foundation
@testable import BitcoinOverview

class MockBackend: Backend {
    
    var urlSession = URLSession()
    
    var baseURL = ""
    
    @discardableResult
    func perform(_ request: Request, completion: ((Result<Data, BackendError>) -> Void)?) -> URLSessionTask? {
        
        return nil
    }
}
