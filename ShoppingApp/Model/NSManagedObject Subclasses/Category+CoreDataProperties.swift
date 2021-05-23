//
//  Category+CoreDataProperties.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/23/21.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var name: String?
    @NSManaged public var imageData: Data?
    @NSManaged public var products: NSOrderedSet?

}

// MARK: Generated accessors for products
extension Category {

    @objc(insertObject:inProductsAtIndex:)
    @NSManaged public func insertIntoProducts(_ value: Product, at idx: Int)

    @objc(removeObjectFromProductsAtIndex:)
    @NSManaged public func removeFromProducts(at idx: Int)

    @objc(insertProducts:atIndexes:)
    @NSManaged public func insertIntoProducts(_ values: [Product], at indexes: NSIndexSet)

    @objc(removeProductsAtIndexes:)
    @NSManaged public func removeFromProducts(at indexes: NSIndexSet)

    @objc(replaceObjectInProductsAtIndex:withObject:)
    @NSManaged public func replaceProducts(at idx: Int, with value: Product)

    @objc(replaceProductsAtIndexes:withProducts:)
    @NSManaged public func replaceProducts(at indexes: NSIndexSet, with values: [Product])

    @objc(addProductsObject:)
    @NSManaged public func addToProducts(_ value: Product)

    @objc(removeProductsObject:)
    @NSManaged public func removeFromProducts(_ value: Product)

    @objc(addProducts:)
    @NSManaged public func addToProducts(_ values: NSOrderedSet)

    @objc(removeProducts:)
    @NSManaged public func removeFromProducts(_ values: NSOrderedSet)

}

extension Category : Identifiable {

}
