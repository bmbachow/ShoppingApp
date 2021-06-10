//
//  SplashView.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 6/10/21.
//

import Foundation
import UIKit

class SplashView: UIView {
    
    let imageView: UIImageView
    
    func setConstraintsEqualTo(view: UIView) {
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.topAnchor.constraint(equalTo: view.topAnchor),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    init() {
        self.imageView = UIImageView(image: UIImage(named: "Bazaar-removebg-preview"))
        super.init(frame: .zero)
        NSLayoutConstraint.activate([
            self.imageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1),
            self.imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1),
            self.imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
