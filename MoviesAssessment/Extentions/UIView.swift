import UIKit

extension UIView {

    // MARK: Pin to Edges
    func addSubviewPinnedToEdges(_ view: UIView) {
        addSubviewPinnedToEdges(view, leading: 0, top: 0, trailing: 0, bottom: 0)
    }

    func addSubviewPinnedToEdges(_ view: UIView, leading: CGFloat, top: CGFloat, trailing: CGFloat, bottom: CGFloat) {
        addSubview(view)
        pinSubviewToEdges(view, leading: leading, top: top, trailing: trailing, bottom: bottom)
    }

    func pinSubviewToEdges(_ subview: UIView, leading: CGFloat = 0, top: CGFloat = 0, trailing: CGFloat = 0, bottom: CGFloat = 0) {
        guard subviews.contains(subview) else { return }
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leading).isActive = true
        subview.topAnchor.constraint(equalTo: topAnchor, constant: top).isActive = true
        subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: trailing).isActive = true
        subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottom).isActive = true
    }

    // MARK: Round edges
    func roundCorners(with radius: CGFloat = 4) {
        let center = self.center
        layer.cornerRadius = radius
        self.center = center
        clipsToBounds = true
    }
    
    func showActivityIndicator() {
        let indicator = UIView.init(frame: self.bounds)
        indicator.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let activityIndicator = UIActivityIndicatorView.init(style: .large)
        activityIndicator.startAnimating()
        activityIndicator.center = indicator.center
        indicator.tag = 100
        DispatchQueue.main.async {
            indicator.addSubview(activityIndicator)
            self.addSubview(indicator)
        }
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            if let background = self.viewWithTag(100){
                background.removeFromSuperview()
            }
            self.isUserInteractionEnabled = true
        }
    }
}
extension UIViewController {
    func showAlert(alertText : String, alertMessage : String) {let alert = UIAlertController(title: alertText, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)  }
}
