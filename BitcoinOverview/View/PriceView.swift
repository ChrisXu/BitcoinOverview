//
//  PriceView.swift
//  BitcoinOverview
//
//  Created by Chris Xu on 2019/4/15.
//  Copyright © 2019 CXCreation. All rights reserved.
//

import UIKit

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
