//
//  CustomPaddingTextView.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 6/1/21.
//

import UIKit

class CustomPaddingTextView: UITextView {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.textContainer.lineFragmentPadding = CGFloat(0.0)
        self.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.contentInset = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
    }
    
}
