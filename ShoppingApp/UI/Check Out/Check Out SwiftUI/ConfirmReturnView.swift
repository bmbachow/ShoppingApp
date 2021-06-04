//
//  ConfirmReturnView.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 6/3/21.
//

import SwiftUI

protocol SwiftUIConfirmReturnDelegate: AnyObject {
    func confirmReturn(amount: Double, onAlertDismissed: @escaping () -> Void)
}

struct ConfirmReturnView: View {
    
    let remoteAPI: RemoteAPI
    
    let cartItem: CartItem
    
    @ObservedObject var orderData: OrderData
    
    var numberReturnable: Int16 {
        return cartItem.number - cartItem.numberReturned
    }
    
    @State var numberToReturn = 1
    
    var refundAmount: Double { cartItem.product!.price * Double(self.numberToReturn) }
    
    weak var delegate: SwiftUIConfirmReturnDelegate?

    @Binding var isPresented: Bool
    

    var body: some View {
        FormVStack {
            StandardText("Product return", size: 19, style: .semiBold)
            Spacer()
            VStack {
                HStack {
                    Image(uiImage: cartItem.product?.image ?? UIImage(systemName: "questionmark")!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 75, height: 75)
                    if cartItem.number > 1 {
                        StandardText("ⅹ\(cartItem.number)", size: 20, style: .bold)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                            .background(Color(UIConstants.secondaryButtonColor))
                            .foregroundColor(.white)
                            .cornerRadius(6)
                    }
                }
                StandardText(cartItem.product?.name ?? "?", size: 17)
                    .lineLimit(10)
                    .fixedSize(horizontal: false, vertical: true)
                FormSpacer()
                HStack(alignment: .bottom) {
                    StandardText("Refund amount", size: 19, style: .semiBold)
                        .lineLimit(1)
                    Spacer()
                    StandardText(NumberFormatter.dollars.string(from: self.refundAmount)!, size: 21, style: .semiBold)
                }
            }
            if self.numberReturnable > 1 {
                FormHStack {
                    StandardText("How many?")
                    Spacer()
                    Text("\(self.numberToReturn)")
                    Stepper("\(self.numberToReturn)", value: self.$numberToReturn, in: 1...Int(numberReturnable))
                        .labelsHidden()
                }
            }
            StandardButton(action: {
                self.remoteAPI.returnItems(cartItem: self.cartItem, numberToReturn: self.numberToReturn, success: { order in
                    self.orderData.order = order
                    self.delegate?.confirmReturn(amount: self.refundAmount, onAlertDismissed: {
                        self.isPresented = false
                    })
                }, failure: { error in
                    print(error.localizedDescription)
                })
            }, labelText: "Confirm return")
            StandardButton(action: {
                self.isPresented = false
            }, labelText: "Cancel")
            Spacer()
        }
    }
}


