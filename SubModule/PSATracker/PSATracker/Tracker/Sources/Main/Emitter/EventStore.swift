

import Foundation

/// Protocol to implement storage for events that are queued to be sent.
@objc(SPEventStore)
public protocol EventStore: NSObjectProtocol {
    /// Adds an event to the store.
    /// - Parameter payload: the payload to be added
    @objc
    func addEvent(_ payload: Payload)
    /// Removes an event from the store.
    /// - Parameter storeId: the identifier of the event in the store.
    /// - Returns: a boolean of success to remove.
    @objc
    func removeEvent(withId storeId: Int64) -> Bool
    /// Removes a range of events from the store.
    /// - Parameter storeIds: the events' identifiers in the store.
    /// - Returns: a boolean of success to remove.
    @objc
    func removeEvents(withIds storeIds: [Int64]) -> Bool
    /// Empties the store of all the events.
    /// - Returns: a boolean of success to remove.
    @objc
    func removeAllEvents() -> Bool
    /// Returns amount of events currently in the store.
    /// - Returns: the count of events in the store.
    @objc
    func count() -> UInt
    /// Returns a list of EmitterEvent objects which contains events and related ids.
    /// - Parameter queryLimit: is the maximum number of events returned.
    /// - Returns: EmitterEvent objects containing storeIds and event payloads.
    @objc
    func emittableEvents(withQueryLimit queryLimit: UInt) -> [EmitterEvent]
}
