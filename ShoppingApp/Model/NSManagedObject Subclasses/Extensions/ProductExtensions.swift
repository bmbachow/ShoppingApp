//
//  ProductExtensions.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/23/21.
//

import Foundation
import UIKit

extension Product {
    var reviewsArray: [ProductReview] {
        self.reviews?.array as? [ProductReview] ?? []
    }
    
    var averageRating: Double? {
        let reviews = self.reviewsArray
        guard reviews.count > 0 else { return nil }
        let total: Double = reviews.reduce(Double(0), { result , review in
            result + Double(review.rating)
        })
        return total/Double(reviews.count)
    }
    
    var numberOfRatings: Int {
        return self.reviewsArray.count
    }
    
    var image: UIImage? {
        guard let data = self.imageData else { return nil }
        return UIImage(data: data)
    }
    
    func setImageDataFromImage(_ image: UIImage?) {
        guard let imageData = image?.pngData() else { return }
        self.imageData = imageData
    }
}
