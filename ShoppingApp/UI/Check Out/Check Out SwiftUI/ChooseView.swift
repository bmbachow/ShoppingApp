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
    let mode: ChooseView.Mode
    
    weak var delegate: SwiftUICheckoutViewDelegate?
    
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
            return AnyView(ChooseView(remoteAPI: self.remoteAPI, orderData: self.orderData, mode: .paymentMethod, delegate: self.delegate))
        case .paymentMethod:
            return AnyView(OrderSummaryView(remoteAPI: self.remoteAPI, orderData: self.orderData, mode: .checkout, delegate: self.delegate))
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
        ScrollView {
            LazyVStack {
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
                    StandardText(self.emptyMessageForCurrentMode)
                }
                Spacer()
                    .frame(height: 14)
                switch self.mode {
                case .address:
                    StandardButton2(action: {
                        self.navigationSelection = 2
                    }, labelText: "Add new address")
                    .buttonStyle(BorderlessButtonStyle())
                    Spacer()
                        .frame(height: 14)
                    Separator()
                case .paymentMethod:
                    Menu {
                        Button(action: {
                            self.navigationSelection = 4
                        }, label: {
                            StandardText("Credit or debit card")
                        })
                        Button(action: {
                            self.navigationSelection = 5
                        }, label: {
                            StandardText("Personal checking account")
                        })
                    } label: {
                        Text("Add new payment method")
                            .font(Font(UIConstants.standardFont(size: 15, style: .semiBold)))
                            .foregroundColor(Color(UIConstants.secondaryButtonColor))
                    }
                    Spacer()
                        .frame(height: 14)
                    Separator()
                    Spacer()
                        .frame(height: 14)
                    StandardButton2(action: {
                        self.orderData.paymentMethod = nil
                        self.navigationSelection = 1
                    }, labelText: "Pay with cash on delivery")
                    Spacer()
                        .frame(height: 14)
                    Separator()
                }
            }            .navigationTitle(Text(self.titleTextForCurrentMode))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if self.mode == .address {
                        Button(action: {self.delegate?.cancel()}) { Text("Cancel") }
                    }
                }
            }
            .listStyle(PlainListStyle())
            .onAppear(perform: {
                self.orderData.address = self.selectedAddress
                self.orderData.paymentMethod = self.selectedPaymentMethod
            })
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
        //.modifier(ColorTopSafeArea(.white))
    }
    
}
