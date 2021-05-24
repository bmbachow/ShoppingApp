//
//  ShoppingAdTableViewCell.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/24/21.
//

import UIKit

class ShoppingAdTableViewCell: UITableViewCell {
    
    @IBOutlet weak var shoppingImage: UIImageView!
    
    private var timer = Timer()
    
    var images : [UIImage] = [UIImage(named: "shopping0")!, UIImage(named: "shopping1")!, UIImage(named: "shopping2")!]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func startAdTimer(){
        self.timer.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: 12.0, repeats: true) { timer in
            self.shoppingImage.image = self.images.randomElement()
        }
    }
    
    func invalidateTimer(){
        self.timer.invalidate()
    }
}
