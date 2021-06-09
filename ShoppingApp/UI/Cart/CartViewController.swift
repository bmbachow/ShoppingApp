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
    
    @IBOutlet weak var emptyCartView: UIView!
    
    @IBOutlet weak var cartHeaderView: UIView!
    
    
    
    var subtotalAmountLabelText: String {
        NumberFormatter.dollars.string(from: self.user?.cartSubtotal ?? 0) ?? "?"
    }
    
    var cartItems: [CartItem] {
        return self.user?.cartItemsArray ?? []
    }
    
    var cartHasItems: Bool {
        return !self.cartItems.isEmpty
    }
    
    override var shouldShowEmptyPromptView: Bool {
        return self.cartItems.isEmpty
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
        self.navigationItem.title = "Cart"
        
        self.emptyPromptView.setUp(image: UIImage(named: "bluecart")!, labelText: "Your cart is empty...", buttonTitle: "Continue shopping")
 
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshCartHeaderVisibility(animated: false)
        self.updateEmptyPromptViewVisibility(animated: false, completion: nil)
    }
    
    func updateSubtotalAmountLabel() {
        self.subtotalAmountLabel?.text = self.subtotalAmountLabelText
    }
    
    @IBAction func tappedCheckOutButton(_ sender: UIButton) {
        guard let user = self.user, !(self.user is AnonymousUser) else {
            return self.presentNotSignedInAlert()
        }
        if user.cartSubtotal < OrderData.freeShippingThreshold {
            self.presentFreeShippingAlert(
                currentSubtotal: user.cartSubtotal,
                cancelAction: {},
                continueAction: { [weak self] in
                    self?.goToCheckOut()
                })
        } else {
            self.goToCheckOut()
        }
    }
    
    override func cartChanged(_ notification: Notification) {
        super.cartChanged(notification)
        guard notification.object as? UserTabViewController != self else { return }
        self.refreshCart()
    }
    
    func refreshCart() {
        self.view.setNeedsLayout()
        self.updateSubtotalAmountLabel()
        self.tableView?.reloadData()
    }
    
    func refreshCartHeaderVisibility(animated: Bool) {
        let visible = self.cartHasItems
        let action = {
            self.cartHeaderView.isHidden = !visible
            self.tableView?.contentInset.top = visible ? self.cartHeaderView.frame.height : 0
            self.cartHeaderView.alpha = visible ? 1 : 0
        }
        if animated {
            UIView.animate(withDuration: 0.5, animations: {
                action()
            }, completion: {_ in action()})
        } else {
            action()
        }
    }
    
    override func wishListChanged(_ notification: Notification) {
        super.wishListChanged(notification)
    }
    
    override func userChanged(_ notification: Notification) {
        super.cartChanged(notification)
        guard notification.object as? UserTabViewController != self else { return }
        self.refreshCart()
    }
    
    override func tappedEmptyPromptButton(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 0
    }
    
    func goToCheckOut() {
        guard let user = self.user else { return }
        let orderViewController = CheckoutViewController(user: user, cartItems: self.cartItems, remoteAPI: self.remoteAPI,
                                                      cancelAction: { [weak self] in
                                                        self?.dismiss(animated: true, completion: nil)
                                                      }, confirmedOrderAction: { [weak self] order in
                                                        self?.refreshCart()
                                                        Notifications.postCartChanged(fromViewController: self)
                                                        self?.dismiss(animated: true, completion: nil)
                                                      }, continueShoppingAction: { [weak self] order in
                                                        self?.refreshCart()
                                                        Notifications.postCartChanged(fromViewController: self)
                                                        self?.tabBarController?.selectedIndex = 0
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
        let value = Int(cell.stepper.value)
        
        
        self.remoteAPI.changeCartItemNumber(cartItem: cartItem, number: value, success: {
            cell.numberLabel.text = String(self.cartItems[indexPath.row].number)
            Notifications.postCartChanged(fromViewController: self)
            self.updateSubtotalAmountLabel()
            
            if value == 0 {
                Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: {_ in 
                    self.deleteCartItem(atIndexPath: indexPath)
                })
            }
            
        }, failure: { error in
            cell.stepper.value = Double(cartItem.number)
            print(error.localizedDescription)
        })
        
        
    }
    
    func tappedDeleteButton(inCell cell: CartProductTableViewCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else {
            return
        }
        self.deleteCartItem(atIndexPath: indexPath)
    }
    
    func deleteCartItem(atIndexPath indexPath: IndexPath) {
        let cartItem = self.cartItems[indexPath.row]
        print(self.cartItems.count)
        self.tableView.beginUpdates()
        self.remoteAPI.deleteItemFromCart(cartItem: cartItem, success: {
            print(self.cartItems.count)
            self.tableView.deleteRows(at: [indexPath], with: .right)
            self.tableView.endUpdates()
            Notifications.postCartChanged(fromViewController: self)
            self.updateSubtotalAmountLabel()
            self.refreshCartHeaderVisibility(animated: true)
            self.updateEmptyPromptViewVisibility(animated: true, completion: nil)
        }, failure: { error in
            self.tableView.endUpdates()
            print(error.localizedDescription)
        })
    }
}
