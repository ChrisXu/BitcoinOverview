//
//  Backend.swift
//  BitcoinOverview
//
//  Created by Chris Xu on 2019/4/13.
//  Copyright © 2019 CXCreation. All rights reserved.
//

import Foundation

public protocol Backend {
    
    var urlSession: URLSession { get }
    
    var baseURL: String { get }
    
    @discardableResult
    func perform(_ request: Request, completion: ((Result<Data, BackendError>) -> Void)?) -> URLSessionTask?
}

public extension Backend {
    
    func perform(_ request: Request, completion: ((Result<Data, BackendError>) -> Void)?) -> URLSessionTask? {
        
        guard let url = request.url(withBaseURL: baseURL) else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod
        urlRequest.httpBody = request.httpBody
        
        if let additionalHeaders = request.headers {
            additionalHeaders.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.key) }
        }
        
        let task = urlSession.dataTask(with: urlRequest) { (data, response, error) in
            
            do {
                guard error == nil else { throw error! }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw BackendError.invalid("Invalid response")
                }
                
                let statusCode = httpResponse.statusCode
                guard 200...299 ~= statusCode else {
                    let message = HTTPURLResponse.localizedString(forStatusCode: statusCode)
                    throw BackendError.invalid("Invalid statusCode \(statusCode) - \(message)")
                }
                
                guard let data = data else {
                    throw BackendError.notFound("Data cannot be found")
                }
                
                completion?(Result.success(data))
            } catch {
                let backendError = BackendError(error: error)
                completion?(Result.failure(backendError))
            }
        }
        
        task.resume()
        
        return task
    }
}

public enum Result<Success, Failure: Error> {
    
    case success(Success)
    case failure(Failure)
}

public struct Request {
    
    typealias HTTPMethod = String
    
    let httpMethod: HTTPMethod
    let path: String
    var headers: [String: String]?
    var queryItems: [URLQueryItem]?
    var httpBody: Data?
    
    init(httpMethod: HTTPMethod, path: String, headers: [String: String]? = nil, httpBody: Data? = nil) {
        self.httpMethod = httpMethod
        self.path = path
        self.headers = headers
        self.httpBody = httpBody
    }
    
    func url(withBaseURL baseURL: String) -> URL? {
        
        guard var urlComponents = URLComponents(string: baseURL) else {
            return nil
        }
        
        urlComponents.path = path
        urlComponents.queryItems = queryItems
        
        return urlComponents.url
    }
}

public enum BackendError: Error {
    
    case invalid(String)
    case notFound(String)
    case undefined(String)
    
    init(error: Error) {
        if let error = error as? BackendError {
            self = error
        } else {
            self = BackendError.undefined(error.localizedDescription)
        }
    }
}
