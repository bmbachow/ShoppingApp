//
//  ShoppingAdTableViewCell.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/24/21.
//

import UIKit

class ShoppingAdTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var shoppingImage: UIImageView!
    
    @IBOutlet weak var pageCon: UIPageControl!
    private var timer = Timer()
    
    var images : [UIImage] = [UIImage(named: "shopping0")!, UIImage(named: "shopping1")!, UIImage(named: "shopping2")!]
    
    var currentImageIndex: Int {
        self.images.firstIndex(of: self.shoppingImage.image!)!
    }
    
    func nextImage(forward: Bool) -> UIImage {
        var index: Int
        let currentIndex = self.currentImageIndex
        if forward {
            if currentIndex < self.images.count - 1 {
                index = currentIndex + 1
            } else {
                index = 0
            }
        } else {
            if currentIndex > 0 {
                index = currentIndex - 1
            } else {
                index = self.images.count - 1
            }
        }
        return self.images[index]
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.shoppingImage.image = images[0]
        self.pageCon.numberOfPages = self.images.count
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.swipedImageLeft))
        leftSwipe.direction = .left
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.swipedImageRight))
        rightSwipe.direction = .right
        
        self.shoppingImage.gestureRecognizers = [leftSwipe, rightSwipe]
        self.shoppingImage.isUserInteractionEnabled = true
    }
    
    @objc func swipedImageLeft(_ sender: UISwipeGestureRecognizer) {
        self.changeToImage(forward: true, options: .transitionCrossDissolve)
        self.startAdTimer()
    }
    
    @objc func swipedImageRight(_ sender: UISwipeGestureRecognizer) {
        self.changeToImage(forward: false, options: .transitionCrossDissolve)
        self.startAdTimer()
    }
    
    func startAdTimer(){
        self.timer.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: 6.0, repeats: true) { timer in
            self.changeToImage(forward: true, options: .transitionCrossDissolve)
        }
    }
    
    func changeToImage(forward: Bool, options: UIView.AnimationOptions) {
        UIView.transition(with: self.shoppingImage,
                          duration: 0.5,
                          options: options,
                          animations: {
                            self.shoppingImage.image = self.nextImage(forward: forward)
                          },
                          completion: nil)
        self.pageCon.currentPage = self.currentImageIndex
    }
    
    func invalidateTimer(){
        self.timer.invalidate()
    }
}
