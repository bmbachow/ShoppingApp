//
//  CheckoutViewController.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/27/21.
//

import UIKit
import SwiftUI

class CheckoutViewController: BaseViewController, SwiftUICheckoutViewDelegate {
    
    let orderData: OrderData
    let cancelAction: () -> Void
    let orderConfirmedAction: (Order) -> Void
    
    var hostingController: UIHostingController<AnyView> = EmptyView().wrappedInUIHostingController()
    
    
    init(user: User, cartItems: [CartItem], remoteAPI: RemoteAPI, cancelAction: @escaping () -> Void, confirmedOrderAction: @escaping (Order) -> Void) {
        let orderData = OrderData(user: user)
        self.cancelAction = cancelAction
        self.orderConfirmedAction = confirmedOrderAction
        self.orderData = orderData
        super.init(nibName: nil, bundle: nil)
        self.hostingController = CheckoutNavigationView(remoteAPI: remoteAPI, orderData: self.orderData, delegate: self).wrappedInUIHostingController()
        self.addChild(hostingController)
        self.view.addSubview(hostingController.view)
        self.hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.hostingController.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.hostingController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.hostingController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.hostingController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: SwiftUIOrderViewDelegate
    
    func cancel() {
        self.cancelAction()
    }
    
    func orderConfirmed(_ order: Order) {
        self.orderConfirmedAction(order)
    }

}
