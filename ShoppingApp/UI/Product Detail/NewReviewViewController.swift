//
//  NewReviewViewController.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 6/1/21.
//

import UIKit
import SwiftUI

class NewReviewViewController: BaseViewController, UITextViewDelegate {

    @IBOutlet weak var mainStackView: UIStackView!
    
    @IBOutlet weak var cosmosView: CosmosView!
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var bodyTextView: UITextView!
    
    @IBOutlet weak var submitReviewButton: UIButton!
    
    private let user: User
    
    private let product: Product
    
    private let review: ProductReview?
    
    private let reviewSubmittedAction: () -> Void
    
    private var shouldDisableSubmitReviewButton: Bool {
        return self.getReviewData() == nil
    }
    
    init(user: User, product: Product, review: ProductReview?, reviewSubmittedAction: @escaping () -> Void) {
        self.user = user
        self.product = product
        self.review = review
        self.reviewSubmittedAction = reviewSubmittedAction
        super.init(nibName: "NewReviewViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cosmosView.rating = 0
        self.cosmosView.starSize = Double(self.mainStackView.frame.width/6)

        self.cosmosView.didFinishTouchingCosmos = { [weak self] rating in
            self?.tappedCosmosView()
        }
        
        self.bodyTextView.delegate = self
        self.bodyTextView.layer.borderColor = UIColor(named: "textViewBorderColor")!.cgColor
        self.bodyTextView.layer.borderWidth = 0.8
        self.bodyTextView.layer.cornerRadius = 6
        self.bodyTextView.layer.cornerCurve = .continuous
        
        self.updateReviewButtonStatus()
    }
    
    @IBAction func tappedSubmitReviewButton(_ sender: UIButton) {
        guard let reviewData = self.getReviewData() else {
            return
        }
        if self.review == nil {
            self.remoteAPI.postNewProductReview(user: self.user, product: self.product, title: reviewData.title, body: reviewData.body, rating: reviewData.rating, success: { productReview in
                self.reviewSubmittedAction()
            }, failure: { error in
                print(error.localizedDescription)
            })
        } else {
            
        }
    }
    
    @IBAction func titleTextFieldChanged(_ sender: UITextField) {
        self.updateReviewButtonStatus()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.updateReviewButtonStatus()
    }
    
    func tappedCosmosView() {
        self.updateReviewButtonStatus()
    }
    
    func updateReviewButtonStatus() {
        self.submitReviewButton.isEnabled = !self.shouldDisableSubmitReviewButton
    }
    
    private func getReviewData() -> (title: String, body: String, rating: StarRating)? {
        guard let title = titleTextField.textnoEmptyString,
              let body = bodyTextView.textNoEmptyString,
              let rating = StarRating(rawValue: Int16(self.cosmosView.rating)) else {
            return nil
        }
        return(title: title, body: body, rating: rating)
    }
}
