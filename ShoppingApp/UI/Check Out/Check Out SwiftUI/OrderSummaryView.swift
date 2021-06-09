//
//  OrderSummaryView.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 6/1/21.
//

import SwiftUI


struct OrderSummaryView: View {
    
    enum Mode {
        case checkout
        case orderDetail
    }
    
    let remoteAPI: RemoteAPI
    @ObservedObject var orderData: OrderData
    @State var showingThankYou = false
    @State var showingReturnConfirmation = false
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let mode: Mode
    
    weak var delegate: SwiftUICheckoutViewDelegate?
    
    weak var confirmReturnDelegate: SwiftUIConfirmReturnDelegate?
    
    var shippingText: String {
        let shipping = self.shippingAndHandling
        if shipping == 0 {
            return "Free"
        } else {
            return NumberFormatter.dollars.string(from: shipping)!
        }
    }
    
    var cartItems: [CartItem] {
        switch self.mode {
        case .checkout:
            return self.orderData.user.cartItemsArray
        case .orderDetail:
            return self.orderData.order!.cartItemsArray
        }
    }
    
    var shippingAndHandling: Double {
        switch self.mode {
        case .checkout:
            return self.orderData.calculatedShipping
        case .orderDetail:
            return self.orderData.order!.shippingPrice
        }
    }
    
    var tax: Double {
        switch self.mode {
        case .checkout:
            return self.orderData.calculatedTax
        case .orderDetail:
            return self.orderData.order!.tax
        }
    }
    
    var totalBeforeGiftCard: Double {
        switch self.mode {
        case .checkout:
            return self.orderData.totalBeforeGiftCard
        case .orderDetail:
            return self.orderData.order!.total + self.orderData.order!.amountPaidWithGiftCardBalance
        }
    }
    
    var totalAfterGiftCard: Double {
        switch self.mode {
        case .checkout:
            return self.orderData.totalAfterGiftCard
        case .orderDetail:
            return self.orderData.order!.total
        }
    }
    
    var paymentMethod: PaymentMethod {
        switch self.mode {
        case .checkout:
            return self.orderData.paymentMethod!
        case .orderDetail:
            return self.orderData.order!.paymentMethod!
        }
    }
    
    var amountPaidWithGiftCardBalance: Double? {
        let amount: Double
        switch self.mode {
        case .checkout:
            amount = self.orderData.amountPaidWithGiftCardBalance <= self.totalBeforeGiftCard ? self.orderData.amountPaidWithGiftCardBalance : self.totalBeforeGiftCard
        case .orderDetail:
            amount = self.orderData.order!.amountPaidWithGiftCardBalance
        }
        return amount > 0 ? amount : nil
    }
    
    var address: Address {
        switch self.mode {
        case .checkout:
            return self.orderData.address!
        case .orderDetail:
            return self.orderData.order!.delivery!.address!
        }
    }
    var body: some View {
        ScrollView {
            LazyVStack {
                FormVStack {
                    if self.mode == .checkout {
                        StandardButton1(action: {
                            self.placeOrder()
                        }, labelText: "Place order")
                    }
                    
                    ForEach(self.cartItems) { cartItem in
                        VStack {
                            FormHStack {
                                ZStack {
                                    Image(uiImage: cartItem.product?.image ?? UIImage(systemName: "questionmark")!)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 55, height: 55)
                                    if cartItem.number > 1 {
                                        StandardText("ⅹ\(cartItem.number)", size: 13, style: .bold)
                                            .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
                                            .background(Color(UIConstants.secondaryButtonColor))
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
                            if self.mode == .orderDetail && self.orderData.order?.deliveryStatus == .delivered {
                                if cartItem.numberUnreturned > 0 {
                                    Spacer()
                                    StandardButton2(action: {
                                        self.orderData.returnItem = cartItem
                                        print(self.showingReturnConfirmation)
                                        self.showingReturnConfirmation = true
                                    }, labelText: "Return item\(cartItem.number > 1 ? "(s)" : "")")
                                    Spacer()
                                }
                                if cartItem.numberReturned > 0 {
                                    HStack {
                                        Spacer()
                                        StandardText("Returned\(cartItem.numberReturned > 1 ? " \(cartItem.numberReturned)" : "") for a refund of \(NumberFormatter.dollars.string(from: cartItem.product!.price * Double(cartItem.numberReturned))!).", size: 15)
                                            .padding(5)
                                            .background(Color(UIConstants.lightGrayCapsule))
                                            .cornerRadius(5)
                                        Spacer()
                                    }
                                    Spacer()
                                        .frame(height: 8)
                                }
                            }
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
                        StandardText(NumberFormatter.dollars.string(from: self.tax)!)
                    }
                    
                    if let amountPaidWithGiftCardBalance = self.amountPaidWithGiftCardBalance {
                        FormHStack {
                            StandardText("Total before gift card:", size: 15)
                            Spacer()
                            StandardText(NumberFormatter.dollars.string(from: self.totalBeforeGiftCard)!, size: 17)
                        }
                        FormHStack {
                            StandardText("Gift card balance:", size: 17)
                            Spacer()
                            StandardText("-\(NumberFormatter.dollars.string(from: amountPaidWithGiftCardBalance)!)", size: 17)
                        }
                    }
                    
                    FormHStack {
                        StandardText("Total:", size: 19, style: .semiBold)
                        Spacer()
                        StandardText(NumberFormatter.dollars.string(from: self.totalAfterGiftCard)!, size: 19, style: .semiBold)
                    }
                }
                .listRowInsets(EdgeInsets())
                Separator()
                FormVStack {
                    LabeledVStack(labelText: "Shipping address") {
                        AddressCellView(address: self.address, isSelected: false, navigationAction: {}, editAction: {}, selectedAction: nil, indentSize: 0, addSeparator: false)
                    }
                }
                .listRowInsets(EdgeInsets())
                Separator()
                FormVStack {
                    LabeledVStack(labelText: "Payment method") {
                        PaymentMethodCellView(paymentMethod: self.paymentMethod, amountPaidWithGiftCardBalance: self.amountPaidWithGiftCardBalance, isSelected: false, navigationAction: {}, selectedAction: nil, indentSize: 0, addSeparator: false)
                    }
                }
                .listRowInsets(EdgeInsets())
                Separator()
                if self.mode == .orderDetail {
                    FormVStack {
                        LabeledVStack(labelText: "Order status") {
                            Spacer()
                                .frame(height: 8)
                            HStack {
                                VStack {
                                    StandardText(self.orderData.order!.deliveryStatus.description)
                                }
                                Spacer()
                            }
                            /*
                            Spacer()
                                .frame(height: 8)
                            HStack {
                                Spacer()
                                StandardButton2(action: {}, labelText: "Track order")
                                Spacer()
                            }
 */
                        }
                    }
                    .listRowInsets(EdgeInsets())
                    Separator()
                }
            }
            .fullScreenCover(isPresented: self.$showingThankYou, content: {
                CheckoutThankYouView(order: self.orderData.order!, delegate: self.delegate)
            })
            .fullScreenCover(isPresented: self.$showingReturnConfirmation, content: {
                ConfirmReturnView(remoteAPI: self.remoteAPI, cartItem: self.orderData.returnItem!, orderData: self.orderData, delegate: self.confirmReturnDelegate!, isPresented: self.$showingReturnConfirmation)
            })
            .listRowInsets(EdgeInsets())
        }
        .navigationTitle("Order confirmation")
    }
    
    func placeOrder() {
        self.remoteAPI.placeOrder(user: self.orderData.user, subtotal: self.orderData.user.cartSubtotal, shippingPrice: self.orderData.calculatedShipping, tax: self.orderData.calculatedTax, address: self.orderData.address!, paymentMethod: self.orderData.paymentMethod, amountPaidWithGiftCardBalance: self.amountPaidWithGiftCardBalance, success: { order in
            self.orderData.order = order
            self.showingThankYou = true
            Notifications.postGiftCardBalanceChanged(fromViewController: nil)
            Notifications.postOrdersChanged(fromViewController: nil)
        }, failure: { error in
            print(error.localizedDescription)
        })
    }
}
