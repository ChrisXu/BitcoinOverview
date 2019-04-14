//
//  RestfulBackend.swift
//  BitcoinOverview
//
//  Created by Chris Xu on 2019/4/13.
//  Copyright © 2019 CXCreation. All rights reserved.
//

import Foundation

final class RestfulBackend: Backend {
    
    let urlSession = URLSession(configuration: .ephemeral)
    
    let baseURL = "https://api.coindesk.com"
}
