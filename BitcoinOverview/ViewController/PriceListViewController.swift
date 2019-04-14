//
//  PriceListViewController.swift
//  BitcoinOverview
//
//  Created by Chris Xu on 2019/4/13.
//  Copyright © 2019 CXCreation. All rights reserved.
//

import UIKit

class PriceListViewController: UIViewController {
    
    lazy var presenter: PricePresentable = PricePresenter(backend: RestfulBackend())
    
    var collectionView: UICollectionView! = nil
    private let collectionViewLayout = CollectionViewLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hexString: "#FBFBFB")
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: collectionViewLayout)
        configure(collectionView)
        
        reloadHistoricalPrices()
    }
    
    // MARK: - Public methods
    
    func reloadHistoricalPrices() {
        
        view.showLoading(withColor: UIColor(hexString: "#21B7C1"), activityIndicatorStyle: .whiteLarge)
        
        presenter.reloadHistoricalPrices { [weak self] error in
            DispatchQueue.main.async {
                self?.view.dismissLoading()
                
                if let error = error {
                    self?.handle(error)
                } else {
                    self?.collectionView.reloadData()
                }
            }
        }
    }
    
    func handle(_ error: Error) {
        
    }
    
    // MARK: - Private methods
    
    private func configure(_ collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.clipsToBounds = false

        collectionView.register(PriceCollectionViewCell.self, forCellWithReuseIdentifier: PriceCollectionViewCell.reuseIdentifier)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor),
            collectionView.topAnchor.constraint(equalToSystemSpacingBelow: view.layoutMarginsGuide.topAnchor, multiplier: 1.0),
            collectionView.bottomAnchor.constraint(equalToSystemSpacingBelow: view.layoutMarginsGuide.bottomAnchor, multiplier: 1.0),
            ])
    }
    
    private func configure(_ cell: PriceCollectionViewCell, at index: Int) {
        
        guard let rateText = presenter.rateTextOfHistoricalPrice(at: index),
        let dateText = presenter.dateTextOfHistoricalPrice(at: index) else {
            return
        }
        
        cell.rateLabel.text = rateText
        cell.dateLabel.text = dateText
    }
}

extension PriceListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfHistoricalPrices()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PriceCollectionViewCell.reuseIdentifier, for: indexPath)
        
        if let cell = cell as? PriceCollectionViewCell {
            configure(cell, at: indexPath.item)
        }
        
        return cell
    }
}

extension PriceListViewController: UICollectionViewDelegate {
    
}

private class CollectionViewLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else {
            return
        }
        
        itemSize = CGSize(width: collectionView.bounds.width, height: 74)
        minimumLineSpacing = 16
    }
}
