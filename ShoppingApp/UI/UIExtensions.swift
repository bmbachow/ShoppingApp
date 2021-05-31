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

class roundButton : UIButton{
    
    required init?(coder: NSCoder){
        super.init(coder:coder)
        layer.cornerRadius = 10
        clipsToBounds = true
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
