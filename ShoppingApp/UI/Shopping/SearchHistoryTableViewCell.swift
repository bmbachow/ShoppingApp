//
//  SearchHistoryTableViewCell.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 6/3/21.
//

import UIKit

protocol SearchHistoryTableViewCellDelegate: AnyObject {
    func tappedXButton(inCell cell: SearchHistoryTableViewCell)
}

class SearchHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    weak var delegate: SearchHistoryTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func tappedXButton(_ sender: UIButton) {
        self.delegate?.tappedXButton(inCell: self)
    }
}
