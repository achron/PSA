

import Foundation

/// @protocol SPContextGenerator
/// A context generator used to generate global contexts.
@objc(SPContextGenerator)
public protocol ContextGenerator: NSObjectProtocol {
    /// Takes event information and decide if the context needs to be generated.
    /// - Parameter event: informations about the event to process.
    /// - Returns: whether the context has to be generated.
    @objc
    func filter(from event: InspectableEvent) -> Bool
    /// Takes event information and generates a context.
    /// - Parameter event: informations about the event to process.
    /// - Returns: a user-generated self-describing JSON.
    @objc
    func generator(from event: InspectableEvent) -> [SelfDescribingJson]?
}
