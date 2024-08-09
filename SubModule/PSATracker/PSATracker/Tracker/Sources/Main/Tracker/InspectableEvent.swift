

import Foundation

/// The inspectable properties of the event used to generate contexts.
@objc(SPInspectableEvent)
public protocol InspectableEvent {
    /// The schema of the event
    @objc
    var schema: String? { get }

    /// The name of the event
    @objc
    var eventName: String? { get }

    /// The payload of the event
    @objc
    var payload: [String : Any] { get }

    /// The list of context entities
    @objc
    var entities: [SelfDescribingJson] { get }
}
