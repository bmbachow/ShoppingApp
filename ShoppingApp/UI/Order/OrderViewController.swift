//
//  OrderViewController.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/27/21.
//

import UIKit
import SwiftUI

class OrderViewController: BaseViewController {
    
    let orderData: OrderData
    
    let cancelAction: () -> Void
    
    let firstViewController: UIHostingController<AnyView>
    
    init(user: User, cartItems: [CartItem], cancelAction: @escaping () -> Void) {
        let orderData = OrderData(user: user, cartItems: cartItems)
        self.cancelAction = cancelAction
        self.orderData = orderData
        self.firstViewController = ChooseAddressView(orderData: orderData, cancelAction: cancelAction).wrappedInUIHostingController()
        super.init(nibName: nil, bundle: nil)
        self.addChild(firstViewController)
        self.view.addSubview(firstViewController.view)
        self.firstViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.firstViewController.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.firstViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.firstViewController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.firstViewController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
