

import Foundation

/** Track a product view/detail. */
@objc(SPProductViewEvent)
public class ProductViewEvent: SelfDescribingAbstract {
    /// The product that was viewed in a product detail page.
    @objc
    public var product: ProductEntity
    
    override var schema: String {
        return ecommerceActionSchema
    }
    
    override var payload: [String : Any] {
        let data: [String: Any] = ["type": "product_view"]
        return data
    }
    
    override internal var entitiesForProcessing: [SelfDescribingJson]? {
        get { [product.entity] }
    }
    
    /// - Parameter product: The product that was viewed in a product detail page.
    @objc
    public init(product: ProductEntity) {
        self.product = product
    }
}
