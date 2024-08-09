

import Foundation

/// The inspectable properties of the event used to generate contexts.
protocol StateMachineEvent {
    /// The tracker state at the time the event was sent.
    var state: TrackerStateSnapshot { get }

    /// Add payload values to the event.
    /// - Parameter payload: Map of values to add to the event payload.
    /// - Returns: Whether or not the values have been successfully added to the event payload.
    func addPayloadValues(_ payload: [String : Any]) -> Bool
}
