

import Foundation

class DeepLinkStateMachine: StateMachineProtocol {
    /*
     States: Init, DeepLink, ReadyForOutput
     Events: DL (DeepLinkReceived), SV (ScreenView)
     Transitions:
      - Init (DL) DeepLink
      - DeepLink (SV) ReadyForOutput
      - ReadyForOutput (DL) DeepLink
      - ReadyForOutput (SV) Init
     Entity Generation:
      - ReadyForOutput
     */
    
    static var identifier: String { return "DeepLinkContext" }
    var identifier: String { return DeepLinkStateMachine.identifier }

    var subscribedEventSchemasForTransitions: [String] {
        return [DeepLinkReceived.schema, kSPScreenViewSchema]
    }

    var subscribedEventSchemasForEntitiesGeneration: [String] {
        return [kSPScreenViewSchema]
    }

    var subscribedEventSchemasForPayloadUpdating: [String] {
        return []
    }

    var subscribedEventSchemasForAfterTrackCallback: [String] {
        return []
    }
    
    var subscribedEventSchemasForFiltering: [String] {
        return []
    }

    func transition(from event: Event, state: State?) -> State? {
        if let dlEvent = event as? DeepLinkReceived {
            return DeepLinkState(url: dlEvent.url, referrer: dlEvent.referrer)
        } else {
            if let dlState = state as? DeepLinkState {
                if dlState.readyForOutput {
                    return nil
                }
                let currentState = DeepLinkState(url: dlState.url, referrer: dlState.referrer)
                currentState.readyForOutput = true
                return currentState
            }
        }
        return nil
    }

    func entities(from event: InspectableEvent, state: State?) -> [SelfDescribingJson]? {
        if let deepLinkState = state as? DeepLinkState {
            if !(deepLinkState.readyForOutput) {
                return nil
            }
            let entity = DeepLinkEntity(url: deepLinkState.url)
            entity.referrer = deepLinkState.referrer
            return [entity]
        }
        return nil
    }
    
    func filter(event: InspectableEvent, state: State?) -> Bool? {
        return nil
    }

    func payloadValues(from event: InspectableEvent, state: State?) -> [String : Any]? {
        return nil
    }
    
    func afterTrack(event: InspectableEvent) {
    }
}
