//
//  DateFormatterExtensions.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/25/21.
//

import Foundation

extension DateFormatter {
    static var standardDate: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        return formatter
    }
    
    static var standardTime: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }
}
