//
//  UserTabViewController.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/23/21.
//

import Foundation
import UIKit

class UserTabViewController: BaseViewController {
    
    var user: User? {
        get {
            (self.tabBarController as? UserTabBarController)?.user
        } set {
            (self.tabBarController as? UserTabBarController)?.user = newValue
        }
    }
    
    var userTabBarController: UserTabBarController? {
        return self.tabBarController as? UserTabBarController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Notifications.addUserChangedObserver(self, selector: #selector(self.userChanged(_:)))
        Notifications.addCartChangedObserver(self, selector: #selector(self.cartChanged(_:)))
        Notifications.addWishListChangedObserver(self, selector: #selector(self.wishListChanged(_:)))
        Notifications.addGiftCardBalanceChangedObserver(self, selector: #selector(self.giftCardBalanceChanged(_:)))
        Notifications.addProfilePhotoChangedObserver(self, selector: #selector(self.profilePhotoChanged(_:)))
        Notifications.addOrdersChangedObserver(self, selector: #selector(self.ordersChanged(_:)))
    }
    
    func presentSignInViewController() {
        let signInViewController = SignInViewController(presentingUserTabViewController: self, anonymousUser: self.user as? AnonymousUser, tappedRegisterAction: { [ weak self ] in
            self?.dismiss(animated: true, completion: {
                self?.presentSignUpViewController()
            })
        })
        self.present(signInViewController, animated: true, completion: nil)
    }
    
    func presentSignUpViewController(){
        let registerViewController = RegisterViewController(presentingUserTabViewController: self, anonymousUser: self.user as? AnonymousUser, tappedSignInAction: { [ weak self ] in
            self?.dismiss(animated: true, completion: {
                self?.presentSignInViewController()
            })
        })
        self.present(registerViewController, animated: true ,completion: nil)
    }
    
    func presentNotSignedInAlert() {
        var onDismiss: () -> Void = {}
        self.presentAlertWithActions(
            title: "You aren't signed in",
            message: "Head over to our Sign in or Sign up page to get started.",
            actions: [
                (title: "Sign in", handler: { [weak self] in
                    onDismiss = {self?.presentSignInViewController()}
                }),
                (title: "Sign up", handler: { [weak self] in
                    onDismiss = {self?.presentSignUpViewController()}
                }),
                (title: "Dismiss", handler: {})
            ],
            onDismiss: {
                onDismiss()
            }
        )
    }
    
    func presentFreeShippingAlert(currentSubtotal: Double, cancelAction: @escaping () -> Void, continueAction: @escaping () -> Void) {
        var onDismiss: () -> Void = {}
        self.presentAlertWithActions(
            title: "Want free shipping?",
            message: "Your subtotal is \(NumberFormatter.dollars.string(from: currentSubtotal)!). It needs to be a total of $200 to qualify for free shipping.",
            actions: [
                (title: "Cancel", handler: {
                    onDismiss = {cancelAction()}
                }),
                (title: "Check out", handler: {
                    onDismiss = {continueAction()}
                })
            ],
            onDismiss: {
                onDismiss()
            }
        )
    }
    
    @objc func userChanged(_ notification: Notification) {
        
    }
    
    @objc func cartChanged(_ notification: Notification) {
        
    }
    
    @objc func wishListChanged(_ notification: Notification) {
        
    }
    
    @objc func giftCardBalanceChanged(_ notification: Notification) {
        
    }
    
    @objc func profilePhotoChanged(_ notification: Notification) {
        
    }
    
    
    @objc func ordersChanged(_ notification: Notification) {
        
    }
    
    
    func addProductToCart(_ product: Product, completion: (() -> Void)? = nil) {
        if let user = self.user {
            self.remoteAPI.addProductToCart(product: product, user: user, success: {
                Notifications.postCartChanged(fromViewController: self)
                self.presentFlashAlert(message: "Added to Cart")
                completion?()
            }, failure: { error in
                print(error.localizedDescription)
            })
        }
    }
    
    func addProductToWishList(_ product: Product, completion: (() -> Void)? = nil) {
        if let user = self.user {
            self.remoteAPI.addProductToWishList(product: product, user: user, success: {
                Notifications.postWishListChanged(fromViewController: self)
                self.presentFlashAlert(message: "Added to Wish List")
                completion?()
            }, failure: { error in
                print(error.localizedDescription)
            })
        }
    }
    
    func goToProductDetail(product: Product) {
        let viewController = ProductDetailViewController(product: product)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func goToOrderDetail(order: Order, remoteAPI: RemoteAPI) {
        let viewController = OrderDetailViewController(order: order, remoteAPI: self.remoteAPI)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
