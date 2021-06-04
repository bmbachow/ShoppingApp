//
//  BackButton.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 6/4/21.
//

import Foundation
import UIKit

class BackButton: UIButton {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.tintColor = UIConstants.appOrangeColor
    }
}
