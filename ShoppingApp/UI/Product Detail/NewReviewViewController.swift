//
//  NewReviewViewController.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 6/1/21.
//

import UIKit
import SwiftUI

class NewReviewViewController: BaseViewController {

    @IBOutlet weak var mainStackView: UIStackView!
    
    @IBOutlet weak var cosmosView: CosmosView!
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var bodyTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cosmosView.starSize = Double(self.mainStackView.frame.width/6)
        
        self.bodyTextView.layer.borderColor = UIColor(named: "textViewBorderColor")!.cgColor
        self.bodyTextView.layer.borderWidth = 0.8
        self.bodyTextView.layer.cornerRadius = 6
        self.bodyTextView.layer.cornerCurve = .continuous
    }
}
