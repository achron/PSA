

import Foundation

/// StateFuture represents the placeholder of a future computation.
/// The proper state value is computed when it's observed. Until that moment the StateFuture keeps the elements
/// (event, previous StateFuture, StateMachine) needed to calculate the real state value.
/// For this reason, the StateFuture can be the head of StateFuture chain which will collapse once the StateFuture
/// head is asked to get the real state value.
class StateFuture {
    private var event: Event?
    private var previousState: StateFuture?
    private var stateMachine: StateMachineProtocol?
    private var computedState: State?

    init(event: Event, previousState: StateFuture?, stateMachine: StateMachineProtocol) {
        self.event = event
        self.previousState = previousState
        self.stateMachine = stateMachine
    }

    func computeState() -> State? {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        if computedState == nil {
            if let stateMachine = stateMachine, let event = event {
                computedState = stateMachine.transition(from: event, state: previousState?.computeState())
                previousState = nil
                self.event = nil
                self.stateMachine = nil
            }
        }
        return computedState
    }
}
