//
//  ShoppingViewController.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/23/21.
//

import UIKit

class ShoppingViewController: UserTabViewController {

    
    private var shouldShowSignInViewControllerOnAppear = true
    
    private var products = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.remoteAPI.getAllProducts(success: { products in
            self.products = products
            //when there's a table view:
            //self.tableView.reloadData()
            for product in products {
                print(product.name)
            }
        }, failure: { error in
            print(error.localizedDescription)
        })
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.shouldShowSignInViewControllerOnAppear {
            self.presentSignInViewController()
            self.shouldShowSignInViewControllerOnAppear = false
        }
    }
    
}
