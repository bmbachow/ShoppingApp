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
    let cancelAction: () -> Void
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
            return AnyView(ChooseView(remoteAPI: self.remoteAPI, orderData: self.orderData, cancelAction: {}, mode: .paymentMethod))
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
    
    private func isSelectedAddress(address: Address) -> Bool {
        let selected = address == self.selectedAddress
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
                            let isSelected = self.isSelectedAddress(address: address)
                            AddressCellView(address: address, isSelected: isSelected, navigationAction: {self.navigationSelection = 1})
                        }
                    case .paymentMethod:
                        ForEach(self.orderData.user.addressesArray) { address in
                            let isSelected = self.isSelectedAddress(address: address)
                            AddressCellView(address: address, isSelected: isSelected, navigationAction: {self.navigationSelection = 1})
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
                            self.navigationSelection = 3
                        }, label: {
                            Text("Credit or debit card")
                        })
                        Button(action: {
                            self.navigationSelection = 4
                        }, label: {
                            Text("Personal checking account")
                        })
                    } label: {
                        Text("Add new payment method")
                            .foregroundColor(Color(UIColor.link))
                            .fontWeight(.bold)
                    }
                    
                }
                
            }
            .navigationTitle(Text(self.titleTextForCurrentMode))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: VStack {
                if self.mode == .address {
                    Button(action: self.cancelAction, label: {
                            Text("Cancel")
                                .fontWeight(.regular)
                    })
                }
            })
            .listStyle(PlainListStyle())
            .background(
                VStack{
                    NavigationLink(destination: self.nextPageDestinationForCurrentMode, tag: 1, selection: self.$navigationSelection, label: {EmptyView()})
                    NavigationLink(destination:
                                    NewAddressView(remoteAPI: self.remoteAPI, orderData: self.orderData), tag: 2, selection: self.$navigationSelection,
                                   label: {EmptyView()})
                    NavigationLink(destination:
                                    NewCardPaymentMethodView(remoteAPI: self.remoteAPI, orderData: self.orderData),
                                   tag: 3, selection: self.$navigationSelection, label: {EmptyView()})
                    NavigationLink(destination:
                                    NewAccountPaymentMethodView(remoteAPI: self.remoteAPI, orderData: self.orderData),
                                   tag: 4, selection: self.$navigationSelection, label: {EmptyView()})
                    NavigationLink(destination: EmptyView()) {
                        EmptyView()
                    }
                }
            )
    }
}

/*
struct ChooseAddressView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseAddressView()
    }
}
*/
