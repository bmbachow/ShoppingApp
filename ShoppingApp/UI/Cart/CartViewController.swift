//
//  CartViewController.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/23/21.
//

import UIKit

class CartViewController: UserTabViewController, UITableViewDelegate, UITableViewDataSource, CartProductTableViewCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var subtotalAmountLabel: UILabel!
    
    @IBOutlet weak var checkOutButton: UIButton!
    
    var subtotalAmountLabelText: String {
        NumberFormatter.dollars.string(from: self.user?.cartSubtotal ?? 0) ?? "?"
    }
    
    var cartItems: [CartItem] {
        return self.user?.cartItemsArray ?? []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "CartProductTableViewCell", bundle: nil), forCellReuseIdentifier: "CartProductTableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let footer = UIView()
        footer.backgroundColor = .white
        self.tableView.tableFooterView = footer
        self.updateSubtotalAmountLabel()
    }
    
    func updateSubtotalAmountLabel() {
        self.subtotalAmountLabel?.text = self.subtotalAmountLabelText
    }
    
    @IBAction func tappedCheckOutButton(_ sender: UIButton) {
        guard self.user != nil else { return }
        self.goToCheckOut()
    }
    
    override func cartChanged() {
        super.cartChanged()
        self.updateSubtotalAmountLabel()
        self.tableView?.reloadData()
    }
    
    override func wishListChanged() {
        super.wishListChanged()
    }
    
    func goToCheckOut() {
        guard let user = self.user else { return }
        let orderViewController = OrderViewController(user: user, cartItems: self.cartItems, remoteAPI: self.remoteAPI,
                                                      cancelAction: { [weak self] in
                                                        self?.dismiss(animated: true, completion: nil)
                                                      })
        orderViewController.modalPresentationStyle = .fullScreen
        self.present(orderViewController, animated: true)
    }
    
    //MARK: UITableView
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cartItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cartItem = self.cartItems[indexPath.row]
        let product = self.cartItems[indexPath.row].product!
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartProductTableViewCell") as? CartProductTableViewCell else {
            fatalError("Unable to dequeue CartProductTableViewCell")
        }
        cell.delegate = self
        cell.productImageView.image = product.image
        cell.nameLabel.text = product.name
        cell.priceLabel.text = NumberFormatter.dollars.string(from: Float(product.price))
        cell.numberLabel.text = String(cartItem.number)
        cell.stepper.value = Double(cartItem.number)
        return cell
    }
    
    //MARK: CartProductTableViewCellDelegate
    
    func stepperValueChanged(inCell cell: CartProductTableViewCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else {
            return
        }
        let cartItem = self.cartItems[indexPath.row]
        self.remoteAPI.changeCartItemNumber(cartItem: cartItem, number: Int(cell.stepper.value), success: {
            cell.numberLabel.text = String(self.cartItems[indexPath.row].number)
            self.userTabBarController?.cartChanged(fromViewController: self)
            self.updateSubtotalAmountLabel()
        }, failure: { error in
            cell.stepper.value = Double(cartItem.number)
            print(error.localizedDescription)
        })
    }
    
    func tappedDeleteButton(inCell cell: CartProductTableViewCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else {
            return
        }
        let cartItem = self.cartItems[indexPath.row]
        print(self.cartItems.count)
        self.tableView.beginUpdates()
        self.remoteAPI.deleteItemFromCart(cartItem: cartItem, success: {
            print(self.cartItems.count)
            self.tableView.deleteRows(at: [indexPath], with: .right)
            self.tableView.endUpdates()
            self.userTabBarController?.cartChanged(fromViewController: self)
            self.updateSubtotalAmountLabel()
        }, failure: { error in
            self.tableView.endUpdates()
            print(error.localizedDescription)
        })
    }
}
