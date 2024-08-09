

import Foundation

/// Track a transaction event.
/// Entity schema: `iglu:com.snowplowanalytics.snowplow.ecommerce/transaction/jsonschema/1-0-0`
@objc(SPTransactionEvent)
public class TransactionEvent: SelfDescribingAbstract {
    /// The transaction involved.
    @objc
    public var transaction: TransactionEntity
    
    /// Products in the transaction.
    @objc
    public var products: [ProductEntity]?
    
    override var schema: String {
        return ecommerceActionSchema
    }
    
    override var payload: [String : Any] {
        let data: [String: Any] = ["type": "transaction"]
        return data
    }
    
    override internal var entitiesForProcessing: [SelfDescribingJson]? {
        get {
            var entities = [SelfDescribingJson]()
            
            entities.append(transaction.entity)
            if let products = products {
                for product in products {
                    entities.append(product.entity)
                }
            }
            return entities
        }
    }
    
    /// - Parameter transaction: The transaction details.
    /// - Parameter products: The product(s) included in the transaction.
    @objc
    public init(transaction: TransactionEntity, products: [ProductEntity]? = nil) {
        self.transaction = transaction
        self.products = products
    }
}
