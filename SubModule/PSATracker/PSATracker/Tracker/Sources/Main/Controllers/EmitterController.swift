

import Foundation

@objc(SPEmitterController)
public protocol EmitterController: EmitterConfigurationProtocol {
    /// Number of events recorded in the EventStore.
    @objc
    var dbCount: Int { get }
    /// Whether the emitter is currently sending events.
    @objc
    var isSending: Bool { get }
    @objc
    func flush()
    /// Pause emitting events.
    /// Emitting events will be suspended until resumed again.
    /// Suitable for low bandwidth situations.
    @objc
    func pause()
    /// Resume emitting events if previously paused.
    /// The emitter will resume emitting events again.
    @objc
    func resume()
}
