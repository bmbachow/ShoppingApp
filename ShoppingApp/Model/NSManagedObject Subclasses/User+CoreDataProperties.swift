//
//  User+CoreDataProperties.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/25/21.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var email: String?
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var password: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var searchHistory: [String]?
    @NSManaged public var registeredDate: Date?
    @NSManaged public var cartProducts: NSOrderedSet?
    @NSManaged public var orders: NSOrderedSet?
    @NSManaged public var paymentMethods: NSOrderedSet?
    @NSManaged public var reviews: NSOrderedSet?
    @NSManaged public var wishListProducts: NSOrderedSet?

}

// MARK: Generated accessors for cartProducts
extension User {

    @objc(insertObject:inCartProductsAtIndex:)
    @NSManaged public func insertIntoCartProducts(_ value: Product, at idx: Int)

    @objc(removeObjectFromCartProductsAtIndex:)
    @NSManaged public func removeFromCartProducts(at idx: Int)

    @objc(insertCartProducts:atIndexes:)
    @NSManaged public func insertIntoCartProducts(_ values: [Product], at indexes: NSIndexSet)

    @objc(removeCartProductsAtIndexes:)
    @NSManaged public func removeFromCartProducts(at indexes: NSIndexSet)

    @objc(replaceObjectInCartProductsAtIndex:withObject:)
    @NSManaged public func replaceCartProducts(at idx: Int, with value: Product)

    @objc(replaceCartProductsAtIndexes:withCartProducts:)
    @NSManaged public func replaceCartProducts(at indexes: NSIndexSet, with values: [Product])

    @objc(addCartProductsObject:)
    @NSManaged public func addToCartProducts(_ value: Product)

    @objc(removeCartProductsObject:)
    @NSManaged public func removeFromCartProducts(_ value: Product)

    @objc(addCartProducts:)
    @NSManaged public func addToCartProducts(_ values: NSOrderedSet)

    @objc(removeCartProducts:)
    @NSManaged public func removeFromCartProducts(_ values: NSOrderedSet)

}

// MARK: Generated accessors for orders
extension User {

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

// MARK: Generated accessors for paymentMethods
extension User {

    @objc(insertObject:inPaymentMethodsAtIndex:)
    @NSManaged public func insertIntoPaymentMethods(_ value: PaymentMethod, at idx: Int)

    @objc(removeObjectFromPaymentMethodsAtIndex:)
    @NSManaged public func removeFromPaymentMethods(at idx: Int)

    @objc(insertPaymentMethods:atIndexes:)
    @NSManaged public func insertIntoPaymentMethods(_ values: [PaymentMethod], at indexes: NSIndexSet)

    @objc(removePaymentMethodsAtIndexes:)
    @NSManaged public func removeFromPaymentMethods(at indexes: NSIndexSet)

    @objc(replaceObjectInPaymentMethodsAtIndex:withObject:)
    @NSManaged public func replacePaymentMethods(at idx: Int, with value: PaymentMethod)

    @objc(replacePaymentMethodsAtIndexes:withPaymentMethods:)
    @NSManaged public func replacePaymentMethods(at indexes: NSIndexSet, with values: [PaymentMethod])

    @objc(addPaymentMethodsObject:)
    @NSManaged public func addToPaymentMethods(_ value: PaymentMethod)

    @objc(removePaymentMethodsObject:)
    @NSManaged public func removeFromPaymentMethods(_ value: PaymentMethod)

    @objc(addPaymentMethods:)
    @NSManaged public func addToPaymentMethods(_ values: NSOrderedSet)

    @objc(removePaymentMethods:)
    @NSManaged public func removeFromPaymentMethods(_ values: NSOrderedSet)

}

// MARK: Generated accessors for reviews
extension User {

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

// MARK: Generated accessors for wishListProducts
extension User {

    @objc(insertObject:inWishListProductsAtIndex:)
    @NSManaged public func insertIntoWishListProducts(_ value: Product, at idx: Int)

    @objc(removeObjectFromWishListProductsAtIndex:)
    @NSManaged public func removeFromWishListProducts(at idx: Int)

    @objc(insertWishListProducts:atIndexes:)
    @NSManaged public func insertIntoWishListProducts(_ values: [Product], at indexes: NSIndexSet)

    @objc(removeWishListProductsAtIndexes:)
    @NSManaged public func removeFromWishListProducts(at indexes: NSIndexSet)

    @objc(replaceObjectInWishListProductsAtIndex:withObject:)
    @NSManaged public func replaceWishListProducts(at idx: Int, with value: Product)

    @objc(replaceWishListProductsAtIndexes:withWishListProducts:)
    @NSManaged public func replaceWishListProducts(at indexes: NSIndexSet, with values: [Product])

    @objc(addWishListProductsObject:)
    @NSManaged public func addToWishListProducts(_ value: Product)

    @objc(removeWishListProductsObject:)
    @NSManaged public func removeFromWishListProducts(_ value: Product)

    @objc(addWishListProducts:)
    @NSManaged public func addToWishListProducts(_ values: NSOrderedSet)

    @objc(removeWishListProducts:)
    @NSManaged public func removeFromWishListProducts(_ values: NSOrderedSet)

}

extension User : Identifiable {

}
