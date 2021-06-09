//
//  ProductReview+CoreDataProperties.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 6/9/21.
//
//

import Foundation
import CoreData


extension ProductReview {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductReview> {
        return NSFetchRequest<ProductReview>(entityName: "ProductReview")
    }

    @NSManaged public var body: String?
    @NSManaged public var postedDate: Date?
    @NSManaged public var rating: Int16
    @NSManaged public var title: String?
    @NSManaged public var product: Product?
    @NSManaged public var user: User?

}

extension ProductReview : Identifiable {

}
