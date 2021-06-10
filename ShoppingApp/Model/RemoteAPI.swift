//
//  RemoteAPI.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/23/21.
//

import Foundation
import UIKit

protocol RemoteAPI {
    //MARK: User
    func postNewUser(firstName: String, lastName: String, email: String?, phoneNumber: String?, password: String, anonymousUser: AnonymousUser?, success: (User) -> Void, failure: (Error) -> Void)
    
    func authenticateAndGetUser(emailOrPhoneNumber: String, password: String, anonymousUser: AnonymousUser?, success: (User?) -> Void, failure: (Error) -> Void)
    
    func getUser(emailOrPhoneNumber: String, success: (User?) -> Void, failure: (Error) -> Void)
    
    func addToSearchHistory(user: User, searchString: String, success: () -> Void, failure: (Error) -> Void)
    
    func removeFromSearchHistory(user: User, searchString: String, success: () -> Void, failure: (Error) -> Void)
    
    func postProfileImage(user: User, image: UIImage, success: () -> Void, failure: (Error) -> Void)
    
    //MARK: AnonymousUser
    
    func getAnonymousUserOrCreateIfNotExists(uuid: UUID, success: (AnonymousUser) -> Void, failure: (Error) -> Void)
    
    //MARK: Cart
    
    func addProductToCart(product: Product, user: User, success: () -> Void, failure: (Error) -> Void)
    
    func changeCartItemNumber(cartItem: CartItem, number: Int, success: () -> Void, failure: (Error) -> Void)
    
    func deleteItemFromCart(cartItem: CartItem, success: () -> Void, failure: (Error) -> Void)
    
    //MARK: Wish List
    
    func addProductToWishList(product: Product, user: User, success: () -> Void, failure: (Error) -> Void)
    
    func deleteProductFromWishList(product: Product, user: User, success: () -> Void, failure: (Error) -> Void)
    
    
    //MARK: Product
    func postNewProduct(name: String, category: Category, price: Double, productDescription: String, image: UIImage, success: (Product) -> Void, failure: (Error) -> Void)
    
    func postNewProduct(name: String, categoryName: String, price: Double, productDescription: String, image: UIImage, success: (Product) -> Void, failure: (Error) -> Void)
    
    func getAllProducts(success: ([Product]) -> Void, failure: (Error) -> Void)
    
    func getProducts(searchString: String?, category: Category?, success: ([Product]) -> Void, failure: (Error) -> Void)
    
    //MARK: Order
    func placeOrder(user: User, subtotal: Double, shippingPrice: Double, tax: Double, address: Address, paymentMethod: PaymentMethod?, amountPaidWithGiftCardBalance: Double?, success: (Order) -> Void, failure: (Error) -> Void)
    
    func returnItems(cartItem: CartItem, numberToReturn: Int, success: (Order) -> Void, failure: (Error) -> Void)
    
    //MARK: Category
    
    func getAllCategories(success: ([Category]) ->  Void, failure: (Error) -> Void)
    
    func getCategory(name: String, success: (Category?) -> Void, failure: (Error) -> Void)
    
    func postNewCategory(name: String, image: UIImage, success: (Category) -> Void, failure: (Error) -> Void)
    
    //MARK: ProductReview
    func postNewProductReview(replacingExistingReview existingReview: ProductReview?, user: User?, product: Product, title: String, body: String, rating: StarRating, success: (ProductReview) -> Void, failure: (Error) -> Void)
    
    func patchProductReview(review: ProductReview, title: String?, body: String?, rating: StarRating?, success: (ProductReview) -> Void, failure: (Error) -> Void)
    
    //MARK: Address
    func postNewAddress(user: User, fullName: String, streetAddress: String, streetAddress2: String?, city: String, state: String, zipCode: String, isDefault: Bool, success: (Address) -> Void, failure: (Error) -> Void)

    func patchAddress(address: Address, fullName: String?, streetAddress: String?, streetAddress2: String?, city: String?, state: String?, zipCode: String?, isDefault: Bool?, success: (Address) -> Void, failure: (Error) -> Void)
    
    //MARK: PaymentMethod
    
    func postNewCardPaymentMethod(user: User, nameOnCard: String, cardNumber: String, cvvNumber: String, expirationMonth: Int, expirationYear: Int, isDefault: Bool, success: (CardPaymentMethod) -> Void, failure: (Error) -> Void)
    
    func postNewAccountPaymentMethod(user: User, nameOnAccount: String, accountNumber: String, routingNumber: String, isDefault: Bool, success: (AccountPaymentMethod) -> Void, failure: (Error) -> Void)

}
