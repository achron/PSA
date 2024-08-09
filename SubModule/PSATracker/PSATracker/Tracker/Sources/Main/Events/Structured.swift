

import Foundation

/// A structured event.
@objc(SPStructured)
public class Structured: PrimitiveAbstract {
    /// Name for the group of objects you want to track e.g. "media", "ecomm".
    @objc
    public var category: String
    /// Defines the type of user interaction for the web object.
    ///
    /// E.g., "play-video", "add-to-basket".
    @objc
    public var action: String
    /// Identifies the specific object being actioned.
    ///
    /// E.g., ID of the video being played, or the SKU or the product added-to-basket.
    @objc
    public var label: String?
    /// Describes the object or the action performed on it.
    ///
    /// This might be the quantity of an item added to basket
    @objc
    public var property: String?
    /// Quantifies or further describes the user action.
    ///
    /// This might be the price of an item added-to-basket, or the starting time of the video where play was just pressed.
    @objc
    public var value: NSNumber?

    @objc
    public init(category: String, action: String) {
        self.category = category
        self.action = action
    }

    @objc
    override var eventName: String {
        return kSPEventStructured
    }

    override var payload: [String : Any] {
        var payload: [String : Any] = [:]
        payload[kSPStuctCategory] = category
        payload[kSPStuctAction] = action
        if let label = label { payload[kSPStuctLabel] = label }
        if let property = property { payload[kSPStuctProperty] = property }
        if let value = value {
            payload[kSPStuctValue] = String(format: "%.17g", value.doubleValue)
        }
        return payload
    }
    
    // MARK: - Builders
    
    /// Identifies the specific object being actioned.
    ///
    /// E.g., ID of the video being played, or the SKU or the product added-to-basket.
    @objc
    public func label(_ label: String?) -> Self {
        self.label = label
        return self
    }
    
    /// Describes the object or the action performed on it.
    ///
    /// This might be the quantity of an item added to basket
    @objc
    public func property(_ property: String?) -> Self {
        self.property = property
        return self
    }
    
    /// Quantifies or further describes the user action.
    ///
    /// This might be the price of an item added-to-basket, or the starting time of the video where play was just pressed.
    @objc
    public func value(_ value: NSNumber?) -> Self {
        self.value = value
        return self
    }
}
