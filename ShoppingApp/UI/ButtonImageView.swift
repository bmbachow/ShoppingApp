//
//  ButtonImageView.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 6/4/21.
//

import Foundation
import UIKit

class ButtonImageView: UIImageView {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    //override by setting the correct image, then calling super.refreshImage()
    //at the moment it's just size to fit, but anything else I may or may not add...
    //the only thing that needs to be overridden is the actual image
    
    var touchesBeganPoint: CGPoint?
    var touchesEndedPoint: CGPoint?
    
    var tapAction: (() -> Void)?
    
    var touchesBeganAndEndedAreBothWithinFrame: Bool {
        guard let began = self.touchesBeganPoint, let ended = self.touchesEndedPoint  else {
            return false
        }
        return self.bounds.contains(began) && self.bounds.contains(ended)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.1, animations: {self.alpha = 0.7})
        super.touchesBegan(touches, with: event)
        if let point = touches.first?.location(in: self) {
            self.touchesBeganPoint = point
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.1, animations: {self.alpha = 1})
        super.touchesEnded(touches, with: event)
        if let point = touches.first?.location(in: self) {
            self.touchesEndedPoint = point
            self.checkForTouchUpInside()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        UIView.animate(withDuration: 0.1, animations: {self.alpha = 1})
    }
    
    func checkForTouchUpInside() {
        if self.touchesBeganAndEndedAreBothWithinFrame {
            self.tapAction?()
        }
        self.touchesBeganPoint = nil
        self.touchesEndedPoint = nil
    }
}
