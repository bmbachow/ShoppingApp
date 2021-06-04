//
//  OrderDetailViewController.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 6/2/21.
//

import UIKit
import SwiftUI

class OrderDetailViewController: UserTabViewController, SwiftUICheckoutViewDelegate, SwiftUIConfirmReturnDelegate {

    var hostingController: UIHostingController<AnyView> = EmptyView().wrappedInUIHostingController()
    
    init(order: Order, remoteAPI: RemoteAPI) {
        super.init(nibName: nil, bundle: nil)
        self.hostingController = Text("").wrappedInUIHostingController()
        let orderData = OrderData(user: order.user!)
        orderData.order = order
        self.hostingController = CheckoutConfirmationView(remoteAPI: remoteAPI, orderData: orderData, mode: .orderDetail, confirmReturnDelegate: self).wrappedInUIHostingController()
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
    
    //MARK: SwiftUICheckoutViewDelegate
    
    func cancel() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func orderConfirmed(_ order: Order) {
        
    }
    
    //MARK: SwiftUIConfirmReturnDelegate
    
    func confirmReturn(amount: Double, onAlertDismissed: @escaping () -> Void) {
        let alert = basicAlert(title: "Return initiated", message: "A refund of \(NumberFormatter.dollars.string(from: amount)!) has been added to your gift card balance.", onDismiss: {
            onAlertDismissed()
        })
        self.presentedViewController?.present(alert, animated: false, completion: nil)
        Notifications.postGiftCardBalanceChanged(fromViewController: self)
        Notifications.postOrdersChanged(fromViewController: self)
    }
    

}
