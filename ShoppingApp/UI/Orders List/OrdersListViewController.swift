//
//  OrdersListViewController.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 6/2/21.
//

import UIKit

class OrdersListViewController: UserTabViewController, UITableViewDelegate, UITableViewDataSource, OrderPreviewTableViewCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var topBarView: UIView!
    
    
    var orders: [Order] {
        self.user?.ordersArray ?? []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self 
        self.tableView.register(UINib(nibName: "OrderPreviewTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderPreviewTableViewCell")
        self.navigationItem.title = "Wish List"
        (self.navigationController as? BazaarNavigationController)?.setLogoVisibile(false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    @IBAction func tappedBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func ordersChanged(_ notification: Notification) {
        super.ordersChanged(notification)
        self.tableView?.reloadData()
    }
    
    //MARK: UITableVIew
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "OrderPreviewTableViewCell") as? OrderPreviewTableViewCell else {
            fatalError("Unable to dequeue OrderPreviewTableViewCell")
        }
        let order = self.orders[indexPath.row]
        let dateString: String = {
            guard let date = order.orderedDate else {
                return "date?"
            }
            return DateFormatter.standardDateFullMonth.string(from: date)
        }()
        
        let orderStatus: String = {
            switch order.deliveryStatus {
            case .preparingShipment, .inTransit:
                return order.deliveryStatus.description
            case .delivered:
                return order.deliveryStatus.description + " " + DateFormatter.standardDateShort.string(from: order.delivery!.deliveredDate!)
            }
        }()
        
        cell.configure(
            date: dateString,
            orderStatus: orderStatus,
            orderItems: { () -> [(image: UIImage?, name: String?)] in
                var items = [(image: UIImage?, name: String?)]()
                for item in order.cartItemsArray {
                    items += [(image: item.product?.image, name: item.product?.name)]
                }
                return items
            }()
        )
        cell.delegate = self
        return cell
    }
    
    //MARK: OrderPreviewTableViewCellDelegate
    
    func tappedNext(inCell cell: OrderPreviewTableViewCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else {
            return
        }
        let order = self.orders[indexPath.row]
        self.goToOrderDetail(order: order, remoteAPI: self.remoteAPI)
    }
}
