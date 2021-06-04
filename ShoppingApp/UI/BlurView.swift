//
//  BlurView.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 6/4/21.
//

import Foundation
import UIKit


class BlurView: UIView {
    
    var visualEffectView = UIVisualEffectView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addBlurEffect()
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.addBlurEffect()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addBlurEffect() {
        let bounds = self.bounds
        self.visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        self.visualEffectView.frame = bounds
        self.visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(self.visualEffectView)

        // Here you can add visual effects to any UIView control.
        // Replace custom view with navigation bar in the above code to add effects to the custom view.
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.visualEffectView.frame = self.bounds
    }

}
