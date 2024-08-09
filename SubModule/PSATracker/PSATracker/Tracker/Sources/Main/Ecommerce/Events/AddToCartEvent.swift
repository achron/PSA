

import Foundation

/** Track a product or products being added to cart. */
@objc(SPAddToCartEvent)
public class AddToCartEvent: SelfDescribingAbstract {
    /// List of product(s) that were added to the cart.
    @objc
    public var products: [ProductEntity]

    /// State of the cart after the addition.
    @objc
    public var cart: CartEntity
    
    override var schema: String {
        return ecommerceActionSchema
    }
    
    override var payload: [String : Any] {
        let data: [String: Any] = ["type": "add_to_cart"]
        return data
    }
    
    override internal var entitiesForProcessing: [SelfDescribingJson]? {
        get {
            var entities = [SelfDescribingJson]()
            for product in products {
                entities.append(product.entity)
            }
            entities.append(cart.entity)
            return entities
        }
    }
    
    /// - Parameter products: List of product(s) that were added to the cart.
    /// - Parameter cart: State of the cart after this addition.
    @objc
    public init(products: [ProductEntity], cart: CartEntity) {
        self.products = products
        self.cart = cart
    }
}
