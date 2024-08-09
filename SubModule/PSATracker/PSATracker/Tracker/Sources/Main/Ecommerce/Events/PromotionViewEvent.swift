

import Foundation

/** Track a promotion view. */
@objc(SPPromotionViewEvent)
public class PromotionViewEvent: SelfDescribingAbstract {
    /// The promotion selected.
    @objc
    public var promotion: PromotionEntity
    
    override var schema: String {
        return ecommerceActionSchema
    }
    
    override var payload: [String : Any] {
        let data: [String: Any] = ["type": "promo_view"]
        return data
    }
    
    override internal var entitiesForProcessing: [SelfDescribingJson]? {
        get { [promotion.entity] }
    }
    
    /// - Parameter promotion: The promotion viewed.
    @objc
    public init(promotion: PromotionEntity) {
        self.promotion = promotion
    }
}
