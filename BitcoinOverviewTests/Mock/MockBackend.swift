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
    
    var requestInterceptor: ((Request) -> Data?)?
    
    @discardableResult
    func perform(_ request: Request, completion: ((Result<Data, BackendError>) -> Void)?) -> URLSessionTask? {
        
        do {
            guard let requestInterceptor = requestInterceptor, let data = requestInterceptor(request) else {
                throw BackendError.notFound("Data")
            }
            
            completion?(Result.success(data))
        } catch {
            let wrappedError = BackendError(error: error)
            completion?(Result.failure(wrappedError))
        }
        return nil
    }
}
