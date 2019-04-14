//
//  ViewController.swift
//  BitcoinOverview
//
//  Created by Chris Xu on 2019/4/13.
//  Copyright © 2019 CXCreation. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let service = PriceService(backend: RestfulBackend())
        
        service.fetchHistoricalPrices { result in
            
        }
    }
}

