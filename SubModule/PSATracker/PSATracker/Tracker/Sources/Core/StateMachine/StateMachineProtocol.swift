

import Foundation

protocol StateMachineProtocol {
    var identifier: String { get }
    var subscribedEventSchemasForTransitions: [String] { get }
    var subscribedEventSchemasForEntitiesGeneration: [String] { get }
    var subscribedEventSchemasForPayloadUpdating: [String] { get }
    var subscribedEventSchemasForAfterTrackCallback: [String] { get }
    var subscribedEventSchemasForFiltering: [String] { get }
    
    /// Only available for self-describing events (inheriting from SelfDescribingAbstract)
    func transition(from event: Event, state: State?) -> State?
    
    /// Available for both self-describing and primitive events (when using `*` as the schema)
    func filter(event: InspectableEvent, state: State?) -> Bool?
    
    /// Available for both self-describing and primitive events (when using `*` as the schema)
    func entities(from event: InspectableEvent, state: State?) -> [SelfDescribingJson]?
    
    /// Only available for self-describing events (inheriting from SelfDescribingAbstract)
    func payloadValues(from event: InspectableEvent, state: State?) -> [String : Any]?
    
    /// Available for both self-describing and primitive events (when using `*` as the schema)
    func afterTrack(event: InspectableEvent)
}
