//
//  ShoppingViewController.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/23/21.
//

import UIKit

class ShoppingViewController: UserTabViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var shouldShowSignInViewControllerOnAppear = true
    
    private var products = [Product]()
    
    lazy var adCell : ShoppingAdTableViewCell = {
        return self.tableView.dequeueReusableCell(withIdentifier: "ShoppingAdTableViewCell") as! ShoppingAdTableViewCell
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "ShoppingAdTableViewCell", bundle: nil), forCellReuseIdentifier: "ShoppingAdTableViewCell")
        self.tableView.register(UINib(nibName: "ShoppingProductPreviewTableViewCell", bundle: nil), forCellReuseIdentifier: "ShoppingProductPreviewTableViewCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.remoteAPI.getAllProducts(success: { products in
            self.products = products
            self.tableView.reloadData()
        }, failure: { error in
            print(error.localizedDescription)
        })
        self.adCell.startAdTimer()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.shouldShowSignInViewControllerOnAppear {
            self.presentSignInViewController()
            self.shouldShowSignInViewControllerOnAppear = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.adCell.invalidateTimer()
    }
    
    //MARK: UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return self.products.count
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return self.adCell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
