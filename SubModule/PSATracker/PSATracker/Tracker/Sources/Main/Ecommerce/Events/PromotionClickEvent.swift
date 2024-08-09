

import Foundation

/** Track a promotion click or selection. */
@objc(SPPromotionClickEvent)
public class PromotionClickEvent: SelfDescribingAbstract {
    /// The promotion selected.
    @objc
    public var promotion: PromotionEntity
    
    override var schema: String {
        return ecommerceActionSchema
    }
    
    override var payload: [String : Any] {
        let data: [String: Any] = ["type": "promo_click"]
        return data
    }
    
    override internal var entitiesForProcessing: [SelfDescribingJson]? {
        get { [promotion.entity] }
    }
    
    /// - Parameter promotion: The promotion selected.
    @objc
    public init(promotion: PromotionEntity) {
        self.promotion = promotion
    }
}
