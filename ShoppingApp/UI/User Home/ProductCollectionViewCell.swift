//
//  ProductCollectionViewCell.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/26/21.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageGridView: ImageGridView!
    
    @IBOutlet weak var borderView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.borderView.layer.borderColor = UIColor(named: "textViewBorderColor")!.cgColor
        self.borderView.layer.borderWidth = 0.8
        self.borderView.layer.cornerRadius = 6
        // Initialization code
    }

}
