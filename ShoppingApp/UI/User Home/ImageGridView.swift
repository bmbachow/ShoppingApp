//
//  ImageGridView.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 6/1/21.
//

import Foundation
import UIKit

class ImageGridView: UIView {
    private var imageViews = [UIImageView]()
    
    func setImages(_ images: [UIImage]) {
        for imageView in self.imageViews {
            imageView.removeFromSuperview()
        }
        self.imageViews = []
        for image in images {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            self.imageViews += [imageView]
            self.addSubview(imageView)
        }
        self.setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let across = Int(ceil(sqrt(Double(self.imageViews.count))))
        let imageWidth = self.frame.width / CGFloat(across)
        let imageHeight = self.frame.height / CGFloat(across)
        var row = 0
        var column = 0
        for imageView in self.imageViews {
            imageView.frame = CGRect(x: CGFloat(row) * imageWidth, y: CGFloat(column) * imageHeight, width: imageWidth, height: imageHeight)
            row += 1
            if row == across - 1 {
                row = 0
                column += 1
            }
        }
    }
}
