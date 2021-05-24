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
    
}
