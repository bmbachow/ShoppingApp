//
//  NewCardPaymentMethodView.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/28/21.
//

import SwiftUI

struct NewCardPaymentMethodView: View {
    
    let remoteAPI: RemoteAPI
    @ObservedObject var orderData: OrderData
    @Binding var backButtonText: String
    @Binding var titleText: String
    @Binding var backButtonAction: () -> Void
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ScrollView {
            VStack {
                Text("New card")
            }
            .onAppear(perform: {
                self.titleText = "New credit or debit card"
                self.backButtonText = "< Back"
                self.backButtonAction = {self.presentationMode.wrappedValue.dismiss()}
            })
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

