

import Foundation

/** Track a product list view. */
@objc(SPProductListViewEvent)
public class ProductListViewEvent: SelfDescribingAbstract {
    /// List of products viewed.
    @objc
    public var products: [ProductEntity]
    
    /// The list name.
    @objc
    public var name: String?
    
    override var schema: String {
        return ecommerceActionSchema
    }
    
    override var payload: [String : Any] {
        var data: [String: Any] = ["type": "list_view"]
        if let name = name { data["name"] = name }
        return data
    }
    
    override internal var entitiesForProcessing: [SelfDescribingJson]? {
        get {
            var entities = [SelfDescribingJson]()
            for product in products {
                entities.append(product.entity)
            }
            return entities
        }
    }
    
    /// - Parameter promotion: List of products viewed.
    /// - Parameter name: The list name.
    @objc
    public init(products: [ProductEntity], name: String? = nil) {
        self.products = products
        self.name = name
    }
}
