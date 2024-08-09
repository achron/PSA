

import Foundation

/** Track a product list click or selection event. */
@objc(SPProductListClickEvent)
public class ProductListClickEvent: SelfDescribingAbstract {
    /// Information about the product that was selected.
    @objc
    public var product: ProductEntity
    
    /// The list name.
    @objc
    public var name: String?
    
    override var schema: String {
        return ecommerceActionSchema
    }
    
    override var payload: [String : Any] {
        var data: [String: Any] = ["type": "list_click"]
        if let name = name { data["name"] = name }
        return data
    }
    
    override internal var entitiesForProcessing: [SelfDescribingJson]? {
        get { [product.entity] }
    }
    
    /// - Parameter promotion: Information about the product that was selected.
    /// - Parameter name: The list name.
    @objc
    public init(product: ProductEntity, name: String? = nil) {
        self.product = product
        self.name = name
    }
}
