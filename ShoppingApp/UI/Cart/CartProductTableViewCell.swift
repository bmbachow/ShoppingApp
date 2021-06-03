//
//  CartProductTableViewCell.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/26/21.
//

import UIKit

protocol CartProductTableViewCellDelegate: AnyObject {
    func stepperValueChanged(inCell cell: CartProductTableViewCell)
    func tappedDeleteButton(inCell cell: CartProductTableViewCell)
}

class CartProductTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var stepper: UIStepper!
    
    @IBOutlet weak var numberLabel: UILabel!
    
    weak var delegate: CartProductTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        self.delegate?.stepperValueChanged(inCell: self)
    }
    
    
    @IBAction func tappedDeleteButton(_ sender: UIButton) {
        self.delegate?.tappedDeleteButton(inCell: self)
    }

}
