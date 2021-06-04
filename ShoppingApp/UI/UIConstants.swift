//
//  UIConstants.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/27/21.
//

import Foundation
import UIKit

enum FontStyle: String {
    case regular = ""
    case bold = "-Bold"
    case boldItalic = "-BoldItalic"
    case italic = "-Italic"
    case light = "-Light"
    case lightItalic = "-LightItalic"
    case semiBold = "-SemiBold"
    case semiBoldItalic = "-SemiBoldItalic"
    case ultraBold = "-UltraBold"
}

class UIConstants {
    static let topBarHeight: CGFloat = 64
    static func standardFont(size: CGFloat, style: FontStyle) -> UIFont {
        return UIFont(name: "GillSans" + style.rawValue, size: size)!
    }
    
    static var accentColorApp: UIColor { return UIColor(named: "AccentColorApp")! }
    static var accentColorAppLighter: UIColor { return UIColor(named: "accentColorAppLighter")! }
    static var accentColorAppTranslucent: UIColor { return UIColor(named: "accentColorAppTranslucent")! }
    static var secondaryButtonColor: UIColor { return UIColor(named: "secondaryButtonColor")! }
    static var appOrangeColor: UIColor { return UIColor(named: "appOrangeColor")! }
    static var lightGrayCapsule: UIColor { return UIColor(named: "lightGrayCapsule")! }
}
