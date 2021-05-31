//
//  ChooseView.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/27/21.
//

import SwiftUI

struct ChooseView: View {
    
    enum Mode {
        case address
        case paymentMethod
    }
    
    let remoteAPI: RemoteAPI
    @ObservedObject var orderData: OrderData
    @State var navigationSelection: Int?
    @State var editAddressSelection: Address?
    let cancelAction: (() -> Void)?
    let mode: ChooseView.Mode
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    private var titleTextForCurrentMode: String {
        switch self.mode {
        case .address:
            return "Shipping address"
        case .paymentMethod:
            return "Payment method"
        }
    }
    
    private var emptyMessageForCurrentMode: String {
        switch self.mode {
        case .address:
            return "You have no saved addresses"
        case .paymentMethod:
            return "You have no saved payment methods"
        }
    }
    
    private var nextPageDestinationForCurrentMode: AnyView {
        switch self.mode {
        case .address:
            return AnyView(ChooseView(remoteAPI: self.remoteAPI, orderData: self.orderData, cancelAction: nil, mode: .paymentMethod))
        case .paymentMethod:
            return AnyView(Text("Next view"))
        }
    }
    
    private var selectedAddress: Address? {
        if let address = orderData.address {
            return address
        }
        return orderData.user.defaultAddress
    }
    
    private var selectedPaymentMethod: PaymentMethod? {
        if let paymentMethod = orderData.paymentMethod {
            return paymentMethod
        }
        return orderData.user.defaultPaymentMethod
    }
    
    private func isSelectedAddress(_ address: Address) -> Bool {
        let selected = address == self.selectedAddress
        return selected
    }
    
    
    private func isSelectedPaymentMethod(_ paymentMethod: PaymentMethod) -> Bool {
        let selected = paymentMethod == self.selectedPaymentMethod
        return selected
    }
    
    private func listForCurrentModeIsEmpty() -> Bool {
        switch self.mode {
        case .address:
            return self.orderData.user.addressesArray.count == 0
        case .paymentMethod:
            return self.orderData.user.paymentMethodsArray.count == 0
        }
    }
    
    
    var body: some View {
        
            List {
                if !self.listForCurrentModeIsEmpty() {
                    switch self.mode {
                    case .address:
                        ForEach(self.orderData.user.addressesArray) { address in
                            let isSelected = self.isSelectedAddress(address)
                            AddressCellView(address: address, isSelected: isSelected,
                                            navigationAction: {
                                                self.navigationSelection = 1
                                            }, editAction: {
                                                self.editAddressSelection = address
                                                self.navigationSelection = 3
                                            }, selectedAction: {
                                                self.orderData.address = address
                                            })
                        }
                    case .paymentMethod:
                        ForEach(self.orderData.user.paymentMethodsArray) { paymentMethod in
                            let isSelected = self.isSelectedPaymentMethod(paymentMethod)
                            PaymentMethodCellView(paymentMethod: paymentMethod, isSelected: isSelected,
                                                  navigationAction: {
                                                    self.navigationSelection = 1
                                                  }, selectedAction: {
                                                    self.orderData.paymentMethod = paymentMethod
                                                  })
                        }
                    }
                    
                } else {
                    Text(self.emptyMessageForCurrentMode)
                }
                switch self.mode {
                case .address:
                    Button(action: { self.navigationSelection = 2 }, label: {
                        Text("Add new address")
                            .foregroundColor(Color(UIColor.link))
                            .fontWeight(.bold)
                    })
                    .buttonStyle(BorderlessButtonStyle())
                case .paymentMethod:
                    Menu {
                        Button(action: {
                            self.navigationSelection = 4
                        }, label: {
                            Text("Credit or debit card")
                        })
                        Button(action: {
                            self.navigationSelection = 5
                        }, label: {
                            Text("Personal checking account")
                        })
                    } label: {
                        Text("Add new payment method")
                            .foregroundColor(Color(UIColor.link))
                            .fontWeight(.bold)
                    }
                    StandardButton(action: {
                        self.navigationSelection = 1
                    }, labelText: "Pay with cash on delivery")
                }
                
            }            .navigationTitle(Text(self.titleTextForCurrentMode))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if let cancelAction = self.cancelAction {
                        Button(action: cancelAction) { Text("Cancel") }
                    }
                }
            }
            .listStyle(PlainListStyle())
            .background(
                VStack{
                    NavigationLink(destination: self.nextPageDestinationForCurrentMode, tag: 1, selection: self.$navigationSelection, label: {EmptyView()})
                    NavigationLink(destination:
                                    AddressFormView(remoteAPI: self.remoteAPI, orderData: self.orderData, address: nil), tag: 2, selection: self.$navigationSelection,
                                   label: {EmptyView()})
                    NavigationLink(destination:
                                    AddressFormView(remoteAPI: self.remoteAPI, orderData: self.orderData, address: self.editAddressSelection), tag: 3, selection: self.$navigationSelection,
                                   label: {EmptyView()})
                    NavigationLink(destination:
                                    NewCardPaymentMethodView(remoteAPI: self.remoteAPI, orderData: self.orderData),
                                   tag: 4, selection: self.$navigationSelection, label: {EmptyView()})
                    NavigationLink(destination:
                                    NewAccountPaymentMethodView(remoteAPI: self.remoteAPI, orderData: self.orderData),
                                   tag: 5, selection: self.$navigationSelection, label: {EmptyView()})
                    
                    
                    NavigationLink(destination: EmptyView()) {
                        EmptyView()
                    }
                }
            )
    }
}


