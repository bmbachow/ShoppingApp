//
//  StringExtensions.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/31/21.
//

import Foundation
extension String {
    func capitalizingFirstLetter() -> String {
        return self.prefix(1).capitalized + dropFirst()
    }
}

