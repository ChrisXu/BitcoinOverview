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

class PriceView: UIView {
    
    private(set) var currencyLabel: UILabel!
    private(set) var rateLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addShadow()
    }
    
    // MARK: - Private methods
    
    private func setUp() {
        addCurrencyLabel()
        addRateLabel()
        backgroundColor = .white
    }
    
    private func addCurrencyLabel() {
        currencyLabel = UILabel()
        currencyLabel.accessibilityIdentifier = "PriceView.dateLabel"
        currencyLabel.textColor = UIColor(hexString: "#525252")
        currencyLabel.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        currencyLabel.textAlignment = .left
        
        addSubview(currencyLabel)
        currencyLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            currencyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            currencyLabel.widthAnchor.constraint(equalToConstant: 100),
            currencyLabel.heightAnchor.constraint(equalToConstant: 24),
            currencyLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
    }
    
    private func addRateLabel() {
        rateLabel = UILabel()
        rateLabel.accessibilityIdentifier = "PriceView.rateLabel"
        rateLabel.textColor = UIColor(hexString: "#1B1B1B")
        rateLabel.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        rateLabel.textAlignment = .right
        
        addSubview(rateLabel)
        rateLabel.translatesAutoresizingMaskIntoConstraints = false
        rateLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        let leadingConstraint = rateLabel.leadingAnchor.constraint(equalTo: currencyLabel.trailingAnchor, constant: 16)
        leadingConstraint.priority = UILayoutPriority.defaultLow
        NSLayoutConstraint.activate([
            leadingConstraint,
            rateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            rateLabel.heightAnchor.constraint(equalToConstant: 24),
            rateLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            rateLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 30)
            ])
    }
    
    private var shadowLayer: CAShapeLayer!
    private func addShadow() {
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.fillColor = UIColor.white.cgColor
            shadowLayer.shadowColor = UIColor.black.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 1.0, height: 1.0)
            shadowLayer.shadowOpacity = 0.2
            shadowLayer.shadowRadius = 2
            
            self.layer.insertSublayer(shadowLayer, at: 0)
        }
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 4).cgPath
    }
}
