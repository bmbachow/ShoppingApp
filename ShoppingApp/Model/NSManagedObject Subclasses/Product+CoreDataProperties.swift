//
//  Product+CoreDataProperties.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/23/21.
//
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var productDescription: String?
    @NSManaged public var imageData: Data?
    @NSManaged public var category: Category?
    @NSManaged public var orders: NSOrderedSet?
    @NSManaged public var cartUsers: NSOrderedSet?
    @NSManaged public var wishListUsers: NSOrderedSet?
    @NSManaged public var reviews: NSOrderedSet?

}

// MARK: Generated accessors for orders
extension Product {

    @objc(insertObject:inOrdersAtIndex:)
    @NSManaged public func insertIntoOrders(_ value: Order, at idx: Int)

    @objc(removeObjectFromOrdersAtIndex:)
    @NSManaged public func removeFromOrders(at idx: Int)

    @objc(insertOrders:atIndexes:)
    @NSManaged public func insertIntoOrders(_ values: [Order], at indexes: NSIndexSet)

    @objc(removeOrdersAtIndexes:)
    @NSManaged public func removeFromOrders(at indexes: NSIndexSet)

    @objc(replaceObjectInOrdersAtIndex:withObject:)
    @NSManaged public func replaceOrders(at idx: Int, with value: Order)

    @objc(replaceOrdersAtIndexes:withOrders:)
    @NSManaged public func replaceOrders(at indexes: NSIndexSet, with values: [Order])

    @objc(addOrdersObject:)
    @NSManaged public func addToOrders(_ value: Order)

    @objc(removeOrdersObject:)
    @NSManaged public func removeFromOrders(_ value: Order)

    @objc(addOrders:)
    @NSManaged public func addToOrders(_ values: NSOrderedSet)

    @objc(removeOrders:)
    @NSManaged public func removeFromOrders(_ values: NSOrderedSet)

}

// MARK: Generated accessors for cartUsers
extension Product {

    @objc(insertObject:inCartUsersAtIndex:)
    @NSManaged public func insertIntoCartUsers(_ value: User, at idx: Int)

    @objc(removeObjectFromCartUsersAtIndex:)
    @NSManaged public func removeFromCartUsers(at idx: Int)

    @objc(insertCartUsers:atIndexes:)
    @NSManaged public func insertIntoCartUsers(_ values: [User], at indexes: NSIndexSet)

    @objc(removeCartUsersAtIndexes:)
    @NSManaged public func removeFromCartUsers(at indexes: NSIndexSet)

    @objc(replaceObjectInCartUsersAtIndex:withObject:)
    @NSManaged public func replaceCartUsers(at idx: Int, with value: User)

    @objc(replaceCartUsersAtIndexes:withCartUsers:)
    @NSManaged public func replaceCartUsers(at indexes: NSIndexSet, with values: [User])

    @objc(addCartUsersObject:)
    @NSManaged public func addToCartUsers(_ value: User)

    @objc(removeCartUsersObject:)
    @NSManaged public func removeFromCartUsers(_ value: User)

    @objc(addCartUsers:)
    @NSManaged public func addToCartUsers(_ values: NSOrderedSet)

    @objc(removeCartUsers:)
    @NSManaged public func removeFromCartUsers(_ values: NSOrderedSet)

}

// MARK: Generated accessors for wishListUsers
extension Product {

    @objc(insertObject:inWishListUsersAtIndex:)
    @NSManaged public func insertIntoWishListUsers(_ value: User, at idx: Int)

    @objc(removeObjectFromWishListUsersAtIndex:)
    @NSManaged public func removeFromWishListUsers(at idx: Int)

    @objc(insertWishListUsers:atIndexes:)
    @NSManaged public func insertIntoWishListUsers(_ values: [User], at indexes: NSIndexSet)

    @objc(removeWishListUsersAtIndexes:)
    @NSManaged public func removeFromWishListUsers(at indexes: NSIndexSet)

    @objc(replaceObjectInWishListUsersAtIndex:withObject:)
    @NSManaged public func replaceWishListUsers(at idx: Int, with value: User)

    @objc(replaceWishListUsersAtIndexes:withWishListUsers:)
    @NSManaged public func replaceWishListUsers(at indexes: NSIndexSet, with values: [User])

    @objc(addWishListUsersObject:)
    @NSManaged public func addToWishListUsers(_ value: User)

    @objc(removeWishListUsersObject:)
    @NSManaged public func removeFromWishListUsers(_ value: User)

    @objc(addWishListUsers:)
    @NSManaged public func addToWishListUsers(_ values: NSOrderedSet)

    @objc(removeWishListUsers:)
    @NSManaged public func removeFromWishListUsers(_ values: NSOrderedSet)

}

// MARK: Generated accessors for reviews
extension Product {

    @objc(insertObject:inReviewsAtIndex:)
    @NSManaged public func insertIntoReviews(_ value: ProductReview, at idx: Int)

    @objc(removeObjectFromReviewsAtIndex:)
    @NSManaged public func removeFromReviews(at idx: Int)

    @objc(insertReviews:atIndexes:)
    @NSManaged public func insertIntoReviews(_ values: [ProductReview], at indexes: NSIndexSet)

    @objc(removeReviewsAtIndexes:)
    @NSManaged public func removeFromReviews(at indexes: NSIndexSet)

    @objc(replaceObjectInReviewsAtIndex:withObject:)
    @NSManaged public func replaceReviews(at idx: Int, with value: ProductReview)

    @objc(replaceReviewsAtIndexes:withReviews:)
    @NSManaged public func replaceReviews(at indexes: NSIndexSet, with values: [ProductReview])

    @objc(addReviewsObject:)
    @NSManaged public func addToReviews(_ value: ProductReview)

    @objc(removeReviewsObject:)
    @NSManaged public func removeFromReviews(_ value: ProductReview)

    @objc(addReviews:)
    @NSManaged public func addToReviews(_ values: NSOrderedSet)

    @objc(removeReviews:)
    @NSManaged public func removeFromReviews(_ values: NSOrderedSet)

}

extension Product : Identifiable {

}
