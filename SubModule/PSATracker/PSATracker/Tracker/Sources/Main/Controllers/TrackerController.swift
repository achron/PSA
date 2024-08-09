

import Foundation

@objc(SPTrackerController)
public protocol TrackerController: TrackerConfigurationProtocol {
    /// Version of the tracker.
    @objc
    var version: String { get }
    /// Whether the tracker is running and able to collect/send events.
    /// See `pause()` and `resume()`.
    @objc
    var isTracking: Bool { get }
    /// Namespace of the tracker.
    /// It is used to identify the tracker among multiple trackers running in the same app.
    @objc
    var namespace: String { get }
    /// SubjectController.
    /// @apiNote Don't retain the reference. It may change on tracker reconfiguration.
    @objc
    var subject: SubjectController? { get }
    /// SessionController.
    /// @apiNote Don't retain the reference. It may change on tracker reconfiguration.
    @objc
    var session: SessionController? { get }
    /// NetworkController.
    /// @apiNote Don't retain the reference. It may change on tracker reconfiguration.
    @objc
    var network: NetworkController? { get }
    /// EmitterController.
    /// @apiNote Don't retain the reference. It may change on tracker reconfiguration.
    @objc
    var emitter: EmitterController? { get }
    /// GdprController.
    /// @apiNote Don't retain the reference. It may change on tracker reconfiguration.
    @objc
    var gdpr: GDPRController? { get }
    /// GlobalContextsController.
    /// @apiNote Don't retain the reference. It may change on tracker reconfiguration.
    @objc
    var globalContexts: GlobalContextsController? { get }
    /// PluginsController
    @objc
    var plugins: PluginsController { get }
    /// Media controller for managing media tracking instances and tracking media events.
    @objc
    var media: MediaController { get }
    /// Ecommerce controller for managing ecommerce entity addition.
    @objc
    var ecommerce: EcommerceController { get }
    /// Track the event.
    /// The tracker will take care to process and send the event assigning `event_id` and `device_timestamp`.
    /// - Parameter event: The event to track.
    /// - Returns: The event ID or nil in case tracking is paused
    @objc
    func track(_ event: Event) -> UUID?
    /// Pause the tracker.
    /// The tracker will stop any new activity tracking but it will continue to send remaining events
    /// already tracked but not sent yet.
    /// Calling a track method will not have any effect and event tracked will be lost.
    @objc
    func pause()
    /// Resume the tracker.
    /// The tracker will start tracking again.
    @objc
    func resume()
}
