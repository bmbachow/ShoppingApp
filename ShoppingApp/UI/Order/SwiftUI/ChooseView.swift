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
    @Binding var backButtonText: String
    @Binding var titleText: String
    @Binding var backButtonAction: () -> Void
    @State var navigationSelection: Int?
    let cancelAction: () -> Void
    let mode: ChooseView.Mode
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    private var backButtonTextForCurrentMode: String {
        switch self.mode {
        case .address:
            return "Cancel"
        case .paymentMethod:
            return "< Back"
        }
    }
    
    private var titleTextForCurrentMode: String {
        switch self.mode {
        case .address:
            return "Shipping address"
        case .paymentMethod:
            return "Payment method"
        }
    }
    
    private var addNewTextForCurrentMode: String {
        switch self.mode {
        case .address:
            return "Add new address"
        case .paymentMethod:
            return "Add new payment method"
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
            return AnyView(ChooseView(remoteAPI: self.remoteAPI, orderData: self.orderData, backButtonText: self.$backButtonText, titleText: self.$titleText, backButtonAction: self.$backButtonAction, cancelAction: {}, mode: .paymentMethod))
        case .paymentMethod:
            return AnyView(Text("Next view"))
        }
    }
    
    private var addNewDestinationForCurrentMode: AnyView {
        switch self.mode {
        case .address:
            return AnyView(NewAddressView(remoteAPI: self.remoteAPI, orderData: self.orderData, backButtonText: self.$backButtonText, titleText: self.$titleText, backButtonAction: self.$backButtonAction))
        case .paymentMethod:
            return AnyView(NewPaymentMethodView())
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
                    Text(self.addNewTextForCurrentMode)
                        .foregroundColor(Color(UIColor.link))
                        .fontWeight(.bold)
                })
                .buttonStyle(BorderlessButtonStyle())
            case .paymentMethod:
                Menu {
                    Button(action: {}, label: {
                        Text("Credit or debit card")
                    })
                    Button(action: {}, label: {
                        Text("Personal checking account")
                    })
                } label: {
                    Text(self.addNewTextForCurrentMode)
                        .foregroundColor(Color(UIColor.link))
                        .fontWeight(.bold)
                }

            }
           
        }
        .navigationBarHidden(true)
        .onAppear(perform: {
            self.backButtonText = self.backButtonTextForCurrentMode
            self.titleText = self.titleTextForCurrentMode
            self.backButtonAction = self.mode == .address ? self.cancelAction : {self.presentationMode.wrappedValue.dismiss()}
        })
        .background(
            VStack{
                NavigationLink(destination: self.nextPageDestinationForCurrentMode, tag: 1, selection: self.$navigationSelection, label: {EmptyView()})
                NavigationLink(destination: self.addNewDestinationForCurrentMode, tag: 2, selection: self.$navigationSelection,
                               label: {
                                Text(self.addNewTextForCurrentMode)
                                    .foregroundColor(Color(UIColor.link))
                                    .fontWeight(.bold)
                               })
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
