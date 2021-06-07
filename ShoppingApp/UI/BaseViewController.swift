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
    
    let emptyPromptView = EmptyPromptView()
    
    var shouldShowEmptyPromptView: Bool { false }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem.noTextButton()
        self.view.insertSubview(self.emptyPromptView, at: 0)
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.emptyPromptView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.emptyPromptView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            self.emptyPromptView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.emptyPromptView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
        self.emptyPromptView.button.addTarget(self, action: #selector(self.tappedEmptyPromptButton(_:)), for: .touchUpInside)
        self.updateEmptyPromptViewVisibility(animated: false, completion: nil)
    }
    
    func updateEmptyPromptViewVisibility(animated: Bool, completion: (() -> Void)? ) {
        
        self.view.bringSubviewToFront(self.emptyPromptView)
        
        let action = {
            self.emptyPromptView.alpha = self.shouldShowEmptyPromptView ? 1 : 0
        }
        if animated {
            UIView.animate(withDuration: 0.5, animations: {
                action()
            }, completion: { _ in
                completion?()
            })
        } else {
            action()
        }
    }
    
    @objc func tappedEmptyPromptButton(_ sender: UIButton) {
        
    }
    
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
