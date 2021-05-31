//
//  MonthInt.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/31/21.
//

import Foundation

enum Month: Int, CustomStringConvertible, CaseIterable {
    case january = 1
    case february
    case march
    case april
    case may
    case june
    case july
    case august
    case september
    case october
    case november
    case december
    
    var description: String {
        String(format: "%02d", self.rawValue)
    }
}
