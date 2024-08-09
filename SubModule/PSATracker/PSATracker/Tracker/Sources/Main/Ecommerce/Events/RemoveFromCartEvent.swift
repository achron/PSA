

import Foundation

/** Track a product or products being removed from cart. */
@objc(SPRemoveFromCartEvent)
public class RemoveFromCartEvent: SelfDescribingAbstract {
    /// List of product(s) that were removed from the cart.
    @objc
    public var products: [ProductEntity]

    /// State of the cart after the removal.
    @objc
    public var cart: CartEntity
    
    override var schema: String {
        return ecommerceActionSchema
    }
    
    override var payload: [String : Any] {
        let data: [String: Any] = ["type": "remove_from_cart"]
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
    
    /// - Parameter products: List of product(s) that were removed from the cart.
    /// - Parameter cart: State of the cart after this addition.
    @objc
    public init(products: [ProductEntity], cart: CartEntity) {
        self.products = products
        self.cart = cart
    }
}
