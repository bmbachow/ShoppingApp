//
//  OrderItemView.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 6/2/21.
//

import Foundation
import UIKit

class OrderItemView: UIView {
    let hStack: UIStackView
    let imageView: UIImageView
    let label: UILabel
    
    init(image: UIImage?, labelText: String) {
        self.hStack = UIStackView()
        self.imageView = UIImageView()
        self.label = UILabel()
        super.init(frame: CGRect.zero)
        
        self.hStack.axis = .horizontal
        self.hStack.spacing = 10
        self.hStack.distribution = .equalSpacing
        
        self.label.font = UIFont(name: "GillSans", size: 13)!
        self.label.numberOfLines = 1
        
        self.addSubview(hStack)
        self.hStack.addArrangedSubview(self.imageView)
        self.hStack.addArrangedSubview(self.label)
        
        self.hStack.translatesAutoresizingMaskIntoConstraints = false
        
        self.imageView.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            self.hStack.topAnchor.constraint(equalTo: self.topAnchor),
            self.hStack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.hStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.hStack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.imageView.heightAnchor.constraint(equalToConstant: 45),
            self.imageView.widthAnchor.constraint(equalToConstant: 45)
        ])
        
        self.imageView.image = image ?? UIImage(named: "questionmark.circle.fill")
        self.label.text = labelText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
