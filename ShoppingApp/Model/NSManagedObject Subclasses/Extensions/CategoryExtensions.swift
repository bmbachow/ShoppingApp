//
//  CategoryExtensions.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/23/21.
//

import Foundation
import UIKit

extension Category {
    
    var productsArray: [Product] {
        self.products?.array as? [Product] ?? []
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
