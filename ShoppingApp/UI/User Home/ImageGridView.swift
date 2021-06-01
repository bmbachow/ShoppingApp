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
    private var imageViewFrames = [CGRect]()
    
    private var vStack = UIStackView()
    private func newVStack() -> UIStackView {
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.distribution = .fillEqually
        return vStack
    }
    private func newHStack() -> UIStackView {
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.distribution = .fillEqually
        return hStack
    }
    private var hStacks = UIStackView()
    
    func setImages(_ images: [UIImage]) {
        for imageView in self.imageViews {
            imageView.removeFromSuperview()
        }
        self.imageViews = []
        self.vStack.removeFromSuperview()
        self.vStack = newVStack()
        self.addSubview(self.vStack)
        for image in images {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            self.imageViews += [imageView]
            self.addSubview(imageView)
        }
        self.setupViews()
        self.setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.vStack.frame = self.bounds
    }
    
    func setupViews() {
        let across = Int(ceil(sqrt(Double(self.imageViews.count))))
        var row = 0
        var hStack = self.newHStack()
        self.vStack.addArrangedSubview(hStack)
        for imageView in self.imageViews {
            if row == across {
                row = 0
                hStack = self.newHStack()
                self.vStack.addArrangedSubview(hStack)
            }
            hStack.addArrangedSubview(imageView)
            row += 1
        }
    }
}
