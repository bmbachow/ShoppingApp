//
//  UIExtensions.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/24/21.
//

import Foundation
import UIKit

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

class roundLabel : UILabel{
    
    required init?(coder: NSCoder){
        super.init(coder:coder)
        layer.cornerRadius = 10
        clipsToBounds = true
    }
}
