//
//  OrderPreviewTableViewCell.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 6/2/21.
//

import UIKit

protocol OrderPreviewTableViewCellDelegate: AnyObject {
    func tappedNext(inCell cell: OrderPreviewTableViewCell)
}

class OrderPreviewTableViewCell: BaseTableViewCell {

    @IBOutlet weak var orderItemStackView: UIStackView!
    
    @IBOutlet weak var orderStatusLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var dateStackView: UIStackView!
    
    @IBOutlet weak var dateStackViewSuperview: UIView!
    
    weak var delegate: OrderPreviewTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.dateStackViewSuperview.layer.cornerRadius = 7
        self.dateStackViewSuperview.layer.cornerCurve = .continuous
        self.dateStackViewSuperview.backgroundColor = UIConstants.lightGrayCapsule
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(self.tappedDateStackViewSuperview(_:)))
        self.dateStackViewSuperview.gestureRecognizers = [tapGestureRecognizer]
        /*
        self.dateStackViewSuperview.layer.borderColor = UIColor(named: "textViewBorderColor")!.cgColor
        self.dateStackViewSuperview.layer.borderWidth = 0.8
 */
    }
    
    @objc func tappedDateStackViewSuperview(_ sender: UITapGestureRecognizer) {
        self.delegate?.tappedNext(inCell: self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(date: String, orderStatus: String, orderItems: [(image: UIImage?, name: String?)]) {
        for view in self.orderItemStackView.arrangedSubviews {
            self.orderItemStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        self.dateLabel.text = date
        self.orderStatusLabel.text = orderStatus
        for orderItem in orderItems {
            self.orderItemStackView.addArrangedSubview(OrderItemView(image: orderItem.image, labelText: orderItem.name ?? "item.name?"))
        }
        self.setNeedsLayout()
    }
}
