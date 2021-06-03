//
//  CheckoutConfirmationView.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 6/1/21.
//

import SwiftUI


struct CheckoutConfirmationView: View {
    
    let remoteAPI: RemoteAPI
    var orderData: OrderData
    @State var showingThankYou = false
    
    weak var delegate: SwiftUICheckoutViewDelegate?
    
    var shippingText: String {
        let shipping = self.orderData.calculatedShipping
        if shipping == 0 {
            return "Free"
        } else {
            return NumberFormatter.dollars.string(from: shipping)!
        }
    }
    
    var body: some View {
        List {
            FormVStack {
                
                StandardButton(action: {
                    self.placeOrder()
                }, labelText: "Place order")
                
                ForEach(self.orderData.user.cartItemsArray) { cartItem in
                    FormHStack {
                        ZStack {
                            Image(uiImage: cartItem.product?.image ?? UIImage(systemName: "questionmark")!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 55, height: 55)
                            if cartItem.number > 1 {
                                StandardText("ⅹ\(cartItem.number)", size: 13, style: .bold)
                                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
                                    .background(Color(UIColor.link))
                                    .foregroundColor(.white)
                                    .cornerRadius(4)
                            }
                        }
                        StandardText(cartItem.product?.name ?? "?", size: 15)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                        StandardText(NumberFormatter.dollars.string(from: cartItem.product!.price * Double(cartItem.number))!)
                    }
                }
                Spacer()
                    .frame(height: 6)
                FormHStack {
                    StandardText("Shipping and handling:", size: 15)
                    Spacer()
                    StandardText(self.shippingText)
                }
                FormHStack {
                    StandardText("Tax:", size: 15)
                    Spacer()
                    StandardText(NumberFormatter.dollars.string(from: self.orderData.calculatedTax)!)
                }
                
                FormHStack {
                    StandardText("Total:", size: 19, style: .semiBold)
                    Spacer()
                    StandardText(NumberFormatter.dollars.string(from: self.orderData.total)!, size: 19, style: .semiBold)
                }
            }
            .listRowInsets(EdgeInsets())
            FormVStack {
                LabeledVStack(labelText: "Shipping address") {
                    AddressCellView(address: self.orderData.address!, isSelected: false, navigationAction: {}, editAction: {}, selectedAction: nil)
                }
            }
            .listRowInsets(EdgeInsets())
            FormVStack {
                LabeledVStack(labelText: "Payment method") {
                    PaymentMethodCellView(paymentMethod: self.orderData.paymentMethod, isSelected: false, navigationAction: {}, selectedAction: nil)
                }
            }
            .listRowInsets(EdgeInsets())
        }
        .fullScreenCover(isPresented: self.$showingThankYou, content: {
            CheckoutThankYouView(order: self.orderData.order!, delegate: self.delegate)
        })
    }
    
    func placeOrder() {
        self.remoteAPI.placeOrder(user: self.orderData.user, subtotal: self.orderData.user.cartSubtotal, shippingPrice: self.orderData.calculatedShipping, tax: self.orderData.calculatedTax, address: self.orderData.address!, paymentMethod: self.orderData.paymentMethod, success: { order in
            self.orderData.order = order
            self.showingThankYou = true
            
        }, failure: { error in
            print(error.localizedDescription)
        })
    }
}
