//
//  OrderDetailViewController.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 6/2/21.
//

import UIKit
import SwiftUI

class OrderDetailViewController: UIViewController {

    var hostingController: UIHostingController<AnyView> = EmptyView().wrappedInUIHostingController()
    
    init(user: User, order: Order, remoteAPI: RemoteAPI) {
        super.init(nibName: nil, bundle: nil)
        self.hostingController = Text("").wrappedInUIHostingController()
        //self.hostingController = CheckoutConfirmationView(remoteAPI: remoteAPI, orderData: nil, order: order)
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
}
