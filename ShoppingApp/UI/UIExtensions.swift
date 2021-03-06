//
//  UIExtensions.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/24/21.
//

import Foundation
import UIKit
import SwiftUI

extension View {
    func wrappedInUIHostingController() -> UIHostingController<AnyView> {
        return UIHostingController(rootView: AnyView(self))
    }
    
    func wrappedInUIHostingController() -> UIHostingController<Self> {
        return UIHostingController(rootView: self)
    }
}

extension PreviewProvider {
    var remoteAPI: RemoteAPI { (UIApplication.shared.delegate as! AppDelegate).remoteAPI! }
}

extension UIButton {

    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHighlighted = true
        super.touchesBegan(touches, with: event)
    }

    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHighlighted = false
        super.touchesEnded(touches, with: event)
    }

    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHighlighted = false
        super.touchesCancelled(touches, with: event)
    }
    
}

extension UITextField {
    var textnoEmptyString : String? {
        if(self.text == ""){
            return nil
        }
        return self.text
    }
}

class RoundButton : UIButton{
    
    required init?(coder: NSCoder){
        super.init(coder:coder)
        layer.cornerRadius = 10
        clipsToBounds = true
    }
}

class RoundButton2 : RoundButton {
    
    required init?(coder: NSCoder){
        super.init(coder:coder)
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 30),
            self.widthAnchor.constraint(equalToConstant: 169)
        ])
        
    }
}

extension UIButton {
    func styleAsRoundButton() {
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.titleLabel?.font = UIConstants.standardFont(size: 17, style: .regular)
        self.backgroundColor = UIConstants.accentColorApp
        self.setTitleColor(.black, for: .normal)
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 30),
            self.widthAnchor.constraint(equalToConstant: 169)
        ])
    }
}

extension UIBarButtonItem {
    
    static func noTextButton() -> UIBarButtonItem {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        return backButton
    }
}




class roundLabel : UILabel{
    
    required init?(coder: NSCoder){
        super.init(coder:coder)
        layer.cornerRadius = 10
        clipsToBounds = true
    }
}
        extension UIView
{
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}

extension UITableViewCell {
    func addShadow(backgroundColor: UIColor = .white, cornerRadius: CGFloat = 12, shadowRadius: CGFloat = 5, shadowOpacity: Float = 0.1, shadowPathInset: (dx: CGFloat, dy: CGFloat), shadowPathOffset: (dx: CGFloat, dy: CGFloat)) {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = UIBezierPath(roundedRect: bounds.insetBy(dx: shadowPathInset.dx, dy: shadowPathInset.dy).offsetBy(dx: shadowPathOffset.dx, dy: shadowPathOffset.dy), byRoundingCorners: .allCorners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        
        let whiteBackgroundView = UIView()
        whiteBackgroundView.backgroundColor = backgroundColor
        whiteBackgroundView.layer.cornerRadius = cornerRadius
        whiteBackgroundView.layer.masksToBounds = true
        whiteBackgroundView.clipsToBounds = false
        
        whiteBackgroundView.frame = bounds.insetBy(dx: shadowPathInset.dx, dy: shadowPathInset.dy)
        insertSubview(whiteBackgroundView, at: 0)
    }
    
    
    func hideSeparator(tableViewWidth: CGFloat) {
        self.separatorInset = UIEdgeInsets(top: 0, left: tableViewWidth, bottom: 0, right: 0)
    }
}

extension UITextView {
    var textNoEmptyString : String? {
        if(self.text == ""){
            return nil
        }
        return self.text
    }
}

extension UIView {
    func applyStandardShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 6
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize(width: -2, height: -2)
    }
}

public extension UIImage {
     convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
       let rect = CGRect(origin: .zero, size: size)
       UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
       color.setFill()
       UIRectFill(rect)
       let image = UIGraphicsGetImageFromCurrentImageContext()
       UIGraphicsEndImageContext()
       
       guard let cgImage = image?.cgImage else { return nil }
       self.init(cgImage: cgImage)
     }
   }
