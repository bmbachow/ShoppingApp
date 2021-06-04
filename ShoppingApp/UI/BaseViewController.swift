//
//  BaseViewController.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/23/21.
//

import Foundation
import UIKit
import SwiftUI

class BaseViewController: UIViewController {
    
    var appDelegate: AppDelegate { UIApplication.shared.delegate as! AppDelegate }
    
    var remoteAPI: RemoteAPI { self.appDelegate.remoteAPI! }
    
    func presentSwiftUIView<T: View>(view: T) {
        let hostingController = UIHostingController(rootView: view)
        self.present(hostingController, animated: true, completion: nil)
    }
    
    func presentBasicAlert(title: String? = nil, message: String? = nil, onDismiss: (() -> Void)? = nil) {
        let alert = self.basicAlert(title: title, message: message, onDismiss: onDismiss)
        self.present(alert, animated: true, completion: nil)
    }
    func basicAlert(title: String? = nil, message: String? = nil, onDismiss: (() -> Void)? = nil) -> AlertViewController {
        let alert = AlertViewController(title: title, message: message)
        alert.addAction(title: "OK") {
            self.dismiss(animated: true, completion: {
                onDismiss?()
            })
        }
        return alert
    }
    
    func presentAlertWithActions(title: String? = nil, message: String? = nil, actions: [(title: String, handler: () -> Void)], onDismiss: (() -> Void)? = nil) {
        let alert = AlertViewController(title: title, message: message)
        for action in actions {
            alert.addAction(title: action.title) {
                action.handler()
                self.dismiss(animated: true, completion: {
                    onDismiss?()
                })
            }
        }
        self.present(alert, animated: true, completion: nil)
    }

}
