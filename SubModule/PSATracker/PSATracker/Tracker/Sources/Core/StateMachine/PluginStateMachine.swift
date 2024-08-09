

import Foundation

typealias EntitiesConfiguration = (schemas: [String]?, closure: (InspectableEvent) -> ([SelfDescribingJson]))
typealias AfterTrackConfiguration = (schemas: [String]?, closure: (InspectableEvent) -> ())
typealias FilterConfiguration = (schemas: [String]?, closure: (InspectableEvent) -> Bool)

class PluginStateMachine: StateMachineProtocol {
    var identifier: String
    private var entitiesConfiguration: EntitiesConfiguration?
    private var afterTrackConfiguration: AfterTrackConfiguration?
    private var filterConfiguration: FilterConfiguration?

    init(
        identifier: String,
        entitiesConfiguration: EntitiesConfiguration?,
        afterTrackConfiguration: AfterTrackConfiguration?,
        filterConfiguration: FilterConfiguration?
    ) {
        self.identifier = identifier
        self.entitiesConfiguration = entitiesConfiguration
        self.afterTrackConfiguration = afterTrackConfiguration
        self.filterConfiguration = filterConfiguration
    }

    var subscribedEventSchemasForTransitions: [String] {
        return []
    }

    func transition(from event: Event, state currentState: State?) -> State? {
        return nil
    }

    var subscribedEventSchemasForEntitiesGeneration: [String] {
        if let entitiesConfiguration = entitiesConfiguration {
            if let schemas = entitiesConfiguration.schemas {
                return schemas
            } else {
                return ["*"]
            }
        }
        return []
    }

    func entities(from event: InspectableEvent, state: State?) -> [SelfDescribingJson]? {
        if let entitiesConfiguration = entitiesConfiguration {
            return entitiesConfiguration.closure(event)
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
        if let afterTrackConfiguration = afterTrackConfiguration {
            if let schemas = afterTrackConfiguration.schemas {
                return schemas
            } else {
                return ["*"]
            }
        }
        return []
    }

    func afterTrack(event: InspectableEvent) {
        if let afterTrackConfiguration = afterTrackConfiguration {
            afterTrackConfiguration.closure(event)
        }
    }
    
    var subscribedEventSchemasForFiltering: [String] {
        if let filterConfiguration = filterConfiguration {
            if let schemas = filterConfiguration.schemas {
                return schemas
            } else {
                return ["*"]
            }
        }
        return []
    }
    
    func filter(event: InspectableEvent, state: State?) -> Bool? {
        if let filterConfiguration = filterConfiguration {
            return filterConfiguration.closure(event)
        }
        return nil
    }
}
