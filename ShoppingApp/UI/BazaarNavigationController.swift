//
//  BazaarNavigationController.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 6/4/21.
//

import UIKit

class BazaarNavigationController: UINavigationController {
    let logoImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.logoImageView.alpha = 0
        self.logoImageView.image = UIImage(named: "paperplane2-removebg-preview")!
        self.logoImageView.contentMode = .scaleAspectFit
        self.navigationBar.addSubview(self.logoImageView)
        
        self.navigationBar.backIndicatorImage = UIImage(systemName: "arrow.left")
        self.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "arrow.left")
        
    }
    
    func setLogoVisibile(_ visible: Bool) {
        self.logoImageView.alpha = visible ? 1 : 0
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let bounds = self.navigationBar.bounds
        self.logoImageView.frame = CGRect(x: bounds.origin.x, y: bounds.origin.y - 8, width: bounds.width, height: bounds.height)
    }
}
