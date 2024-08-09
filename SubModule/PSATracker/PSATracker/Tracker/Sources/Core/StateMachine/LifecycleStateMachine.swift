

import Foundation

class LifecycleStateMachine: StateMachineProtocol {
    static var identifier: String { return "Lifecycle" }
    var identifier: String { return LifecycleStateMachine.identifier }

    var subscribedEventSchemasForTransitions: [String] {
        return [kSPBackgroundSchema, kSPForegroundSchema]
    }

    func transition(from event: Event, state currentState: State?) -> State? {
        if let e = event as? Foreground {
            return LifecycleState(asForegroundWithIndex: e.index)
        }
        if let e = event as? Background {
            return LifecycleState(asBackgroundWithIndex: e.index)
        }
        return nil
    }

    var subscribedEventSchemasForEntitiesGeneration: [String] {
        return ["*"]
    }

    func entities(from event: InspectableEvent, state: State?) -> [SelfDescribingJson]? {
        if state == nil {
            let entity = LifecycleEntity(isVisible: true)
            entity.index = 0
            return [entity]
        }
        if let s = state as? LifecycleState {
            let entity = LifecycleEntity(isVisible: s.isForeground)
            entity.index = NSNumber(value: s.index)
            return [entity]
        }
        return nil
    }

    var subscribedEventSchemasForPayloadUpdating: [String] {
        return []
    }

    func payloadValues(from event: InspectableEvent, state: State?) -> [String : Any]? {
        return nil
    }

    var subscribedEventSchemasForAfterTrackCallback: [String] {
        return []
    }

    func afterTrack(event: InspectableEvent) {
    }
    
    var subscribedEventSchemasForFiltering: [String] {
        return []
    }
    
    func filter(event: InspectableEvent, state: State?) -> Bool? {
        return nil
    }
}
