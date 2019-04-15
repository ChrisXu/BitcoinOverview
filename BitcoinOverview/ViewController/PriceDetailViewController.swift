//
//  PriceDetailViewController.swift
//  BitcoinOverview
//
//  Created by Chris Xu on 2019/4/14.
//  Copyright © 2019 CXCreation. All rights reserved.
//

import UIKit

final class PriceDetailViewController: UIViewController {
    
    lazy var presenter: PriceDetailPresentable! = nil
    
    convenience init(presenter: PriceDetailPresentable) {
        self.init()
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = DateFormatter.default().string(from: presenter.date)
        view.backgroundColor = UIColor(hexString: "#FBFBFB")
    }
}
