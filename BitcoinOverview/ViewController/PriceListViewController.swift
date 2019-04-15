//
//  PriceListViewController.swift
//  BitcoinOverview
//
//  Created by Chris Xu on 2019/4/13.
//  Copyright © 2019 CXCreation. All rights reserved.
//

import UIKit

class PriceListViewController: UIViewController {
    
    lazy var presenter: PriceListPresentable! = nil
    
    private var collectionView: UICollectionView! = nil
    private let collectionViewLayout = CollectionViewLayout()
    
    private var currentPriceButton: UIButton! = nil
    private var headerView: UIView! = nil
    
    convenience init(presenter: PriceListPresentable) {
        self.init()
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("Bitcoin price", comment: "")
        view.backgroundColor = UIColor(hexString: "#FBFBFB")
        navigationController?.navigationBar.isTranslucent = false
        
        addHeaderView()
        addCollectionView()
        addCurrentPriceButton()
        
        reloadHistoricalPrices()
        scheduleUpdatingCurrentPrice()
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
    
    func scheduleUpdatingCurrentPrice() {
        
        presenter.scheduleUpdatingCurrentPrice(withTimeInterval: 60) { [weak self] error in
            DispatchQueue.main.async {
                
                if error != nil {
                    self?.currentPriceButton.setTitle("😵", for: .normal)
                    self?.currentPriceButton.isEnabled = false
                } else {
                    let title = self?.presenter.textForCurrentPrice()
                    self?.currentPriceButton.setTitle(title, for: .normal)
                    self?.currentPriceButton.isEnabled = true
                }
            }
        }
    }
    
    func handle(_ error: Error) {
        
    }
    
    // MARK: - Private methods
    
    private func addCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: collectionViewLayout)
        collectionView.accessibilityIdentifier = "PriceListViewController.collectionView"
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.clipsToBounds = false
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(PriceCollectionViewCell.self, forCellWithReuseIdentifier: PriceCollectionViewCell.reuseIdentifier)
        
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor),
            collectionView.topAnchor.constraint(equalToSystemSpacingBelow: view.layoutMarginsGuide.topAnchor, multiplier: 1.0),
            collectionView.bottomAnchor.constraint(equalToSystemSpacingBelow: view.layoutMarginsGuide.bottomAnchor, multiplier: 1.0),
            ])
    }
    
    private func addHeaderView() {
        
        headerView = UIView()
        headerView.backgroundColor = UINavigationBar.appearance().barTintColor
        view.addSubview(headerView)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            headerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            headerView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 120),
            ])
    }
    
    private func addCurrentPriceButton() {
        currentPriceButton = UIButton(type: .system)
        currentPriceButton.accessibilityIdentifier = "PriceListViewController.currentPriceButton"
        currentPriceButton.setTitleColor(.white, for: .normal)
        currentPriceButton.titleLabel?.font = UIFont.systemFont(ofSize: 42, weight: .regular)
        currentPriceButton.addTarget(self, action: #selector(showCurrentPriceDetail), for: .touchUpInside)
        
        view.addSubview(currentPriceButton)
        
        currentPriceButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            currentPriceButton.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
            currentPriceButton.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor),
            currentPriceButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10),
            currentPriceButton.heightAnchor.constraint(equalToConstant: 60),
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
    
    private func adjustHeaderView(with offset: CGFloat) {
        
        let scale = max(headerView.bounds.height - offset, 1) / headerView.bounds.height
        
        let validScale = min(scale, 1)
        if validScale != 1 {
            currentPriceButton.alpha = validScale
            view.bringSubviewToFront(collectionView)
        } else {
            currentPriceButton.alpha = 1
            view.bringSubviewToFront(currentPriceButton)
        }
        
        let translationY = offset > 0 ? -offset * 1.2 : 0
        headerView.transform = CGAffineTransform(translationX: 0, y: translationY)
    }
    
    @objc private func showCurrentPriceDetail() {
        // User the presenter for current price
        if let presenter = presenter.presenterForDetail(at: nil) {
            let detailViewController = PriceDetailViewController(presenter: presenter)
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
            self.navigationController?.pushViewController(detailViewController, animated: true)
        }
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let presenter = presenter.presenterForDetail(at: indexPath.item) {
            let detailViewController = PriceDetailViewController(presenter: presenter)
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
            self.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}

extension PriceListViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        adjustHeaderView(with: scrollView.contentOffset.y)
    }
}

private class CollectionViewLayout: UICollectionViewLayout {
    
    var topPadding: CGFloat = 100 {
        didSet { invalidateLayout() }
    }
    
    var minimumLineSpacing: CGFloat = 16 {
        didSet { invalidateLayout() }
    }
    
    var itemHeight: CGFloat = 74 {
        didSet { invalidateLayout() }
    }
    
    var layoutAttributes: [UICollectionViewLayoutAttributes]?
    private var contentSize = CGSize.zero
    
    override var collectionViewContentSize: CGSize {
        
        guard let collectionView = collectionView, let lastAttributes = layoutAttributes?.last else {
            return CGSize.zero
        }
        
        return CGSize(width: collectionView.bounds.size.width, height: lastAttributes.frame.maxY)
    }
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else {
            return
        }
        
        let numberOfSections = collectionView.numberOfSections
        assert(numberOfSections == 1)
        
        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        
        layoutAttributes = Array(0..<numberOfItems).compactMap { layoutAttribute(at: $0) }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return layoutAttributes
    }
    
    func layoutAttribute(at index: Int) -> UICollectionViewLayoutAttributes? {
        
        guard let collectionView = collectionView else {
            return nil
        }
        
        let indexPath = IndexPath(item: index, section: 0)
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        let itemWidth = collectionView.bounds.size.width
        
        attributes.frame = {
            var frame = CGRect.zero
            frame.origin.x = 0
            frame.origin.y = (CGFloat(index) * (itemHeight + minimumLineSpacing)) + topPadding
            frame.size = CGSize(width: itemWidth, height: itemHeight)
            return frame
        }()
        
        return attributes
    }
}
