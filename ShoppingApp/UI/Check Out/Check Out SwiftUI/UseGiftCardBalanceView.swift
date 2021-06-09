//
//  UseGiftCardBalanceView.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 6/9/21.
//

import Foundation
import SwiftUI

struct UseGiftCardBalanceView: View {

    var isSelected: Bool
    let giftCardBalance: Double
    let navigationAction: () -> Void
    let selectedAction: (() -> Void)?
    
    var indentSize: CGFloat = 24
    var addSeparator = true

    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                    .frame(width: self.indentSize)
                if let selectedAction = self.selectedAction {
                    VStack {
                        Spacer()
                            .frame(height: 14)
                        Image(systemName: self.isSelected ? "checkmark.square.fill" : "square")
                            .font(Font.system(size: 25, weight: self.isSelected ? .regular : .ultraLight))
                            .foregroundColor(Color(UIConstants.secondaryButtonColor))
                            .onTapGesture {
                                selectedAction()
                            }
                            .buttonStyle(BorderlessButtonStyle())
                            .frame(width: 25, height: 25)
                    }
                    Spacer()
                        .frame(width: 26)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Spacer()
                        .frame(height: 8)
                    StandardText("Use \(NumberFormatter.dollars.string(from: self.giftCardBalance)!) gift card balance")
                }
                Spacer()
            }
            /*
            if self.isSelected {
                Spacer()
                    .frame(height: 12)
                HStack {
                    Spacer()
                    StandardButton1(action: self.navigationAction, labelText: "Continue")
                    Spacer()
                }
            }
 */
            Spacer()
                .frame(height: 14)
            if self.addSeparator {
                Separator()
            }
        }
    }
}


