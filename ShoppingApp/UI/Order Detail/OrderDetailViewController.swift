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
    
    let order: Order
    
    init(order: Order, remoteAPI: RemoteAPI) {
        self.order = order
        super.init(nibName: nil, bundle: nil)
        self.hostingController = Text("").wrappedInUIHostingController()
        let orderData = OrderData(user: order.user!)
        orderData.order = order
        self.hostingController = OrderSummaryView(remoteAPI: remoteAPI, orderData: orderData, mode: .orderDetail, confirmReturnDelegate: self).wrappedInUIHostingController()
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        (self.navigationController as? BazaarNavigationController)?.setLogoVisibile(false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Order " + DateFormatter.standardDateShort.string(from: self.order.orderedDate!)
    }
    
    //MARK: SwiftUICheckoutViewDelegate
    
    func cancel() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func orderConfirmed(_ order: Order) {
        
    }
    
    func continueShopping(_ order: Order) {
        
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
