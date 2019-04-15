//
//  TodayViewController.swift
//  BitcoinOverview-Today
//
//  Created by Chris Xu on 2019/4/15.
//  Copyright © 2019 CXCreation. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var priceLabel: UILabel!
    let service = PriceService(backend: RestfulBackend())
    private var updatingTimer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "#38B5CA")
        priceLabel.text = "Loading"
        priceLabel.font = UIFont.systemFont(ofSize: 24.0, weight: .bold)
        
        scheduleUpdatingCurrentPrice()
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
    
    // MARK: - Private method
    
    private func scheduleUpdatingCurrentPrice() {
        updatingTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(updateCurrentPrice), userInfo: nil, repeats: true)
        RunLoop.main.add(updatingTimer, forMode: .common)
        updatingTimer.fire()
    }
    
    @objc private func updateCurrentPrice() {
        service.refreshCurrentPrice { [weak self] result in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                
                do {
                    switch result {
                    case .success(let price):
                        let currency = price.currency
                        guard let text = NumberFormatter.default(for: currency).string(from: NSNumber(value: price.rate)) else {
                            throw ParserError.invalid("Unable to get the rate")
                        }
                        strongSelf.priceLabel.text = text
                    case .failure(let error):
                        throw error
                    }
                } catch {
                    strongSelf.priceLabel.text = "😵"
                }
            }
        }
    }
}
