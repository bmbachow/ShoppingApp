//
//  Product+CoreDataClass.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 6/10/21.
//
//

import Foundation
import CoreData
import UIKit

@objc(Product)
public class Product: NSManagedObject {
    private var _image: UIImage?
    var image: UIImage? {
        if let image = self._image {
            return image
        }
        guard let data = self.imageData else { return nil }
        let image = UIImage(data: data)
        self._image = image
        return image
    }
}
