//
//  PriceTableViewCell.swift
//  BitcoinOverview
//
//  Created by Chris Xu on 2019/4/14.
//  Copyright © 2019 CXCreation. All rights reserved.
//

import UIKit

class PriceCollectionViewCell: UICollectionViewCell, Reusable {

    private(set) var dateLabel: UILabel!
    private(set) var rateLabel: UILabel!
    
    private var shadowLayer: CAShapeLayer!
    
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
    
    override var isHighlighted: Bool{
        didSet{
            UIView.animate(withDuration: 0.2) {
                self.alpha = self.isHighlighted ? 0.7 : 1.0
            }
        }
    }
    
    // MARK: - Private methods
    
    private func setUp() {
        backgroundColor = .white
        contentView.layer.cornerRadius = 4
        
        addDateLabel()
        addRateLabel()
    }
    
    private func addShadow() {
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            
            shadowLayer.path = UIBezierPath(roundedRect: contentView.bounds, cornerRadius: 4).cgPath
            shadowLayer.fillColor = UIColor.white.cgColor
            
            shadowLayer.shadowColor = UIColor.black.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 1.0, height: 1.0)
            shadowLayer.shadowOpacity = 0.2
            shadowLayer.shadowRadius = 2
            
            contentView.layer.insertSublayer(shadowLayer, at: 0)
        }
    }
    
    private func addDateLabel() {
        dateLabel = UILabel()
        dateLabel.accessibilityIdentifier = "PriceCollectionViewCell.dateLabel"
        dateLabel.textColor = UIColor(hexString: "#525252")
        dateLabel.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        dateLabel.textAlignment = .left
        
        contentView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dateLabel.widthAnchor.constraint(equalToConstant: 100),
            dateLabel.heightAnchor.constraint(equalToConstant: 24),
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
    }
    
    private func addRateLabel() {
        rateLabel = UILabel()
        rateLabel.accessibilityIdentifier = "PriceCollectionViewCell.rateLabel"
        rateLabel.textColor = UIColor(hexString: "#1B1B1B")
        rateLabel.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        rateLabel.textAlignment = .right
        
        contentView.addSubview(rateLabel)
        rateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rateLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 16),
            rateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            rateLabel.heightAnchor.constraint(equalToConstant: 24),
            rateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
    }
}
