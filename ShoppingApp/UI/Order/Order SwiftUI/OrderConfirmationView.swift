//
//  OrderConfirmationView.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 6/1/21.
//

import SwiftUI

struct OrderConfirmationView: View {
    
    let remoteAPI: RemoteAPI
    @ObservedObject var orderData: OrderData
    @State var showingThankYou = false
    
    weak var delegate: SwiftUIOrderViewDelegate?
    
    var shippingText: String {
        let shipping = self.orderData.calculatedShipping
        if shipping == 0 {
            return "Free"
        } else {
            return NumberFormatter.dollars.string(from: shipping)!
        }
    }
    
    var body: some View {
        ScrollView {
            FormVStack {
                
                StandardButton(action: {
                    self.placeOrder()
                }, labelText: "Place order")
                
                ForEach(self.orderData.user.cartItemsArray) { cartItem in
                    FormHStack {
                        ZStack {
                            Image(uiImage: cartItem.product?.image ?? UIImage(systemName: "questionmark")!)
                                .resizable()
                                .frame(width: 55, height: 55)
                            if cartItem.number > 1 {
                                Text("ⅹ\(cartItem.number)")
                                    .font(.system(size: 13, weight: .heavy, design: .default))
                                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
                                    .background(Color(UIColor.link))
                                    .foregroundColor(.white)
                                    .cornerRadius(4)
                            }
                        }
                        Text(cartItem.product?.name ?? "?")
                            .lineLimit(2)
                            .font(.system(size: 15, weight: .regular, design: .default))
                        Text(NumberFormatter.dollars.string(from: cartItem.product!.price * Double(cartItem.number))!)
                    }
                }
                FormHStack {
                    Text("Shipping and handling:")
                        .font(.system(size: 15, weight: .regular, design: .default))
                    Spacer()
                    Text(self.shippingText)
                }
                FormHStack {
                    Text("Tax:")
                        .font(.system(size: 15, weight: .regular, design: .default))
                    Spacer()
                    Text(NumberFormatter.dollars.string(from: self.orderData.calculatedTax)!)
                }
                
                FormHStack {
                    Text("Total:")
                        .font(.system(size: 17, weight: .regular, design: .default))
                    Spacer()
                    Text(NumberFormatter.dollars.string(from: self.orderData.total)!)
                        .font(.system(size: 17, weight: .semibold, design: .default))
                }
                
                
                LabeledVStack(labelText: "Shipping address") {
                    AddressCellView(address: self.orderData.address!, isSelected: false, navigationAction: {}, editAction: {}, selectedAction: nil)
                }
                
                LabeledVStack(labelText: "Payment method") {
                    if let paymentMethod = self.orderData.paymentMethod {
                        PaymentMethodCellView(paymentMethod: paymentMethod, isSelected: false, navigationAction: {}, selectedAction: nil)
                    } else {
                        Text("Cash on delivery")
                    }
                }
            }
        }
        .fullScreenCover(isPresented: self.$showingThankYou, content: {
            OrderThankYouView(order: self.orderData.order!, delegate: self.delegate)
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
