//
//  EmptyPromptView.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 6/7/21.
//

import Foundation
import UIKit
 
class EmptyPromptView: UIView {
    
    let imageView = UIImageView()
    let label = UILabel()
    let button = UIButton(type: .system)
    
    let vStack = UIStackView()
    let hStack = UIStackView()
    
    init() {
        super.init(frame: CGRect.zero)
        self.button.styleAsRoundButton()
        self.label.font = UIConstants.standardFont(size: 17, style: .regular)
        
        self.hStack.addArrangedSubview(self.imageView)
        self.hStack.addArrangedSubview(self.label)
        
        self.vStack.addArrangedSubview(self.hStack)
        self.vStack.addArrangedSubview(self.button)
        
        self.vStack.translatesAutoresizingMaskIntoConstraints = false
        self.vStack.axis = .vertical
        self.vStack.spacing = 26
        self.vStack.alignment = .center
        
        self.hStack.translatesAutoresizingMaskIntoConstraints = false
        self.hStack.axis = .horizontal
        self.hStack.spacing = 10
    
        
        self.addSubview(self.vStack)
        
        self.backgroundColor = .white
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.imageView.heightAnchor.constraint(equalToConstant: 61),
            self.imageView.widthAnchor.constraint(equalToConstant: 61),
            NSLayoutConstraint(item: self.vStack, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 0.85, constant: 0),
            self.vStack.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    func setUp(image: UIImage, labelText: String, buttonTitle: String) {
        self.imageView.image = image
        self.label.text = labelText
        self.button.setTitle(buttonTitle, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
