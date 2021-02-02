//
//  UI+Extensions.swift
//  Aster
//
//  Created by Munachimso Ugorji on 02/02/2021.
//

import UIKit

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension UIColor {
    
    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    static var navigationBackgroundColor: UIColor {
        return UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255)
    }
    
    static var indicatorTint: UIColor {
        return UIColor(red: 0 / 255, green: 58 / 255, blue: 123 / 255)
    }
    
    static var priceLabelBackgroundColor: UIColor {
        return UIColor(red: 248 / 255, green: 248 / 255, blue: 248 / 255, alpha: 0.7)
    }
}


extension UICollectionView {
    
    func addPullToRefresh(action: Selector) {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.indicatorTint
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing...")
        refreshControl.addTarget(self,
                                 action: action, for: UIControl.Event.valueChanged)
        self.refreshControl = refreshControl
        self.addSubview(refreshControl)
    }
    
    func stopRefresh() {
        guard let refreshControl = self.refreshControl else { return }
        refreshControl.endRefreshing()
    }
    
    
}

extension NSAttributedString {
    func height(containerWidth: CGFloat) -> CGFloat {
        let rect = self.boundingRect(
            with: CGSize.init(width: containerWidth, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        )
        return ceil(rect.size.height)
    }
}

extension UILabel {
    var estimatedHeight: CGFloat {
        let text = (self.text ?? "") as NSString
        let rect = text.boundingRect(
            with: CGSize(width: frame.size.width, height: CGFloat(Float.infinity)),
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font as Any],
            context: nil
        )

        return ceil(rect.size.height)
    }
}

extension UIView {
    func addShadow(shadowColor: CGColor = UIColor.black.cgColor,
                   shadowOffset: CGSize = CGSize(width: 1.0, height: 2.0),
                   shadowOpacity: Float = 0.4,
                   shadowRadius: CGFloat = 3.0) {
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        self.layoutIfNeeded()
    }
}
