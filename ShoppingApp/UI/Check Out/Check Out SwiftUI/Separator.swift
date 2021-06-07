//
//  Separator.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 6/7/21.
//

import Foundation
import SwiftUI

struct Separator: View {
    var body: some View {
        HStack {
            Spacer()
                .frame(width: 20)
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(Color(UIColor.opaqueSeparator))
        }
    }
}
