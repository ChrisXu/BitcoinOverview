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
    
    private var stackView: UIStackView! = nil
    private var priceViewMap = [Currency: PriceView]()
    
    convenience init(presenter: PriceDetailPresentable) {
        self.init()
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = DateFormatter.default().string(from: presenter.date)
        view.backgroundColor = UIColor(hexString: "#FBFBFB")
        
        addStackView()
        createPriceViews()
        fetchPrices()
    }
    
    // MARK: - Private method
    
    private func addStackView() {
        stackView = UIStackView()
        stackView.accessibilityIdentifier = "PriceDetailViewController.stackView"
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let bottomConstraint = stackView.bottomAnchor.constraint(equalToSystemSpacingBelow: view.layoutMarginsGuide.bottomAnchor, multiplier: 1.0)
        bottomConstraint.priority = UILayoutPriority.defaultLow
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor),
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: view.layoutMarginsGuide.topAnchor, multiplier: 1.0),
            bottomConstraint,
            ])
    }
    
    private func createPriceViews() {
        
        presenter.currecies.forEach { currency in
            
            let priceView = PriceView()
            priceView.accessibilityIdentifier = "PriceDetailViewController.priceView.\(currency.rawValue)"
            priceView.currencyLabel.text = currency.rawValue
            stackView.addArrangedSubview(priceView)
            NSLayoutConstraint.activate([
                priceView.heightAnchor.constraint(equalToConstant: 74),
                priceView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1.0)
                ])
            priceViewMap[currency] = priceView
        }
    }
    
    private func fetchPrices() {
        
        priceViewMap.values.forEach { $0.rateLabel.showLoading(withColor: UIColor(hexString: "#21B7C1"), activityIndicatorStyle: .white) }
        
        presenter.reloadPrices { [weak self] (currency, error) in
            
            guard let strongSelf = self else { return }
            
            DispatchQueue.main.async {
                guard let priceView = strongSelf.priceViewMap[currency] else { return }
                priceView.rateLabel.dismissLoading()
                if error != nil {
                    priceView.rateLabel.text = "😵"
                } else {
                    let rate = strongSelf.presenter.rateTextOfPrice(for: currency)
                    priceView.rateLabel.text = rate
                }
            }
        }
    }
}
