//
//  BaseTableViewCell.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 6/3/21.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func showSelection(_ selected: Bool, animated: Bool, completion: (() -> Void)?) {
        if selected {
            self.isHighlighted = true
            self.highlight(true)
            let timer = Timer(timeInterval: 0, repeats: false) { timer in
                UIView.animate(withDuration: 0.2, animations: {
                    self.highlight(false)
                    self.isHighlighted = false
                }, completion: { _ in
                    completion?()
                })
            }
            RunLoop.main.add(timer, forMode: .common)
        } else {
            self.isHighlighted = false
        }

    }
    
    func highlight(_ highlighted: Bool) {
        if highlighted {
            if self.traitCollection.userInterfaceStyle != .dark {
                self.backgroundColor = UIColor.quaternarySystemFill
            } else {
                self.backgroundColor = UIColor.systemFill
            }
        } else {
            self.backgroundColor = UIColor.systemBackground
        }
    }
}
