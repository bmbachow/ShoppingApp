//
//  MyCollectionViewCell.swift
//  ShoppingApp
//
//  Created by Brian Bachow on 5/25/21.
//

import UIKit

protocol MyCollectionViewCellDelegate : AnyObject {
    func tappedCategoryButton(in cell : MyCollectionViewCell)
}

class MyCollectionViewCell: UICollectionViewCell {
    

    @IBOutlet weak var categoryButton: UIButton!
    
    weak var delegate : MyCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    public func configure (buttonText : String) {
        self.categoryButton.setTitle(buttonText, for: .normal)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "MyCollectionViewCell", bundle: nil)
    }
    
    
    @IBAction func tappedCategoryButton(_ sender: Any) {
        self.delegate?.tappedCategoryButton(in: self)
    }
    
}
