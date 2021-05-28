//
//  OrderContainerView.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/27/21.
//

import SwiftUI

struct OrderContainerView: View {

    let remoteAPI: RemoteAPI
    @ObservedObject var orderData: OrderData
    @State var cancelButtonText: String = ""
    @State var titleText: String = ""
    @State var titleTextTrigger = false
    @State var backButtonAction: () -> Void = {}
    
    let cancelAction: () -> Void
    
    var body: some View {
            VStack {
                ZStack {
                    HStack {
                        Spacer()
                            .frame(width: 12)
                        Button(action: self.backButtonAction, label: {
                            Text(self.cancelButtonText)
                                .foregroundColor(Color(UIColor.link))
                        })
                        Spacer()
                    }
                    Text(self.titleText)
                        .fontWeight(.bold)
                }
                .frame(height: UIConstants.topBarHeight)
                NavigationView {
                    ChooseView(remoteAPI: self.remoteAPI, orderData: self.orderData, backButtonText: self.$cancelButtonText, titleText: self.$titleText, backButtonAction: self.$backButtonAction, cancelAction: self.cancelAction, mode: .address)
                }
                .navigationViewStyle(StackNavigationViewStyle())
            }
    }
}

/*
struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        
    }
}
 */

