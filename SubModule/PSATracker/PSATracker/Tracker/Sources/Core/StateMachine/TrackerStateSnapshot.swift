

import Foundation

protocol TrackerStateSnapshot {
    /// Get a computed state with a specific state identifier
    func state(withIdentifier stateIdentifier: String) -> State?

    /// Get a computed state with a specific state machine
    func state(withStateMachine stateMachine: StateMachineProtocol) -> State?
}
