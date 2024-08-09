

import Foundation

/**
 Controller for managing Ecommerce entities.
 */
@objc(SPEcommController)
public protocol EcommerceController {
    
    /// Add an ecommerce Screen/Page entity to all subsequent events.
    /// - Parameter screen: A EcommScreenEntity.
    @objc
    func setEcommerceScreen(_ screen: EcommerceScreenEntity)
    
    /// Add an ecommerce User entity to all subsequent events.
    /// - Parameter user: A EcommUserEntity.
    @objc
    func setEcommerceUser(_ user: EcommerceUserEntity)
    
    /// Stop adding a Screen/Page entity to events.
    @objc
    func removeEcommerceScreen()
    
    /// Stop adding a User entity to events.
    @objc
    func removeEcommerceUser()
}
