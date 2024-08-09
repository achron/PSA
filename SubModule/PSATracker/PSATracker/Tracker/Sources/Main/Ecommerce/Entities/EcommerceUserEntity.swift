

import Foundation

/**
 Attach Ecommerce User details to events. It is designed to help in modeling guest/non-guest account activity.
 Entity schema: `iglu:com.snowplowanalytics.snowplow.ecommerce/user/jsonschema/1-0-0`
 */
@objc(SPEcommerceUserEntity)
public class EcommerceUserEntity: NSObject {
    /// The user ID.
    @objc
    public var id: String

    /// Whether or not the user is a guest.
    public var isGuest: Bool?

    /// The user's email address.
    @objc
    public var email: String?
    
    internal var entity: SelfDescribingJson {
        var data: [String : Any] = ["id": id]
        if let isGuest = isGuest { data["is_guest"] = isGuest }
        if let email = email { data["email"] = email }
        
        return SelfDescribingJson(schema: ecommerceUserSchema, andData: data)
    }
    
    /// - Parameter id: The user ID.
    /// - Parameter isGuest: Whether or not the user is a guest.
    /// - Parameter email: The user's email address.
    public init(
            id: String,
            isGuest: Bool? = nil,
            email: String? = nil
    ) {
        self.id = id
        self.isGuest = isGuest
        self.email = email
    }
    
    /// - Parameter id: The user ID.
    /// - Parameter email: The user's email address.
    @objc
    public init(
            id: String,
            email: String? = nil
    ) {
        self.id = id
        self.email = email
    }
    
    /// Whether or not the user is a guest.
    @objc
    public func isGuest(_ isGuest: Bool) -> Self {
        self.isGuest = isGuest
        return self
    }
}
