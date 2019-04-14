import UIKit

public protocol LoadingPresentable {
    
    func showLoading(withColor color: UIColor, activityIndicatorStyle: UIActivityIndicatorView.Style)
    
    func dismissLoading()
}

public extension LoadingPresentable where Self: UIView {
    
    private static var tagOfIndicatorView: Int {
        return 20190414
    }
    
    func showLoading(withColor color: UIColor, activityIndicatorStyle: UIActivityIndicatorView.Style = .white) {
        
        let indicatorView = UIActivityIndicatorView(style: activityIndicatorStyle)
        indicatorView.color = color
        indicatorView.tag = Self.tagOfIndicatorView
        indicatorView.hidesWhenStopped = true
        indicatorView.startAnimating()
        
        addSubview(indicatorView)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            indicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
    }
    
    func dismissLoading() {
        if let indicatorView = viewWithTag(Self.tagOfIndicatorView) as? UIActivityIndicatorView {
            indicatorView.stopAnimating()
            indicatorView.removeFromSuperview()
        }
    }
}

extension UIView: LoadingPresentable {}
