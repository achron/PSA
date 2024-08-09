

import Foundation

@objc(SPSessionController)
public protocol SessionController: SessionConfigurationProtocol {
    /// The session index.
    /// An increasing number which helps to order the sequence of sessions.
    @objc
    var sessionIndex: Int { get }
    /// The session identifier.
    /// A unique identifier which is used to identify the session.
    @objc
    var sessionId: String? { get }
    /// The session user identifier.
    /// It identifies this app installation and it doesn't change for the life of the app.
    /// It will change only when the app is uninstalled and installed again.
    /// An app update doesn't change the value.
    @objc
    var userId: String? { get }
    /// Whether the app is currently in background state or in foreground state.
    @objc
    var isInBackground: Bool { get }
    /// Count the number of background transitions in the current session.
    @objc
    var backgroundIndex: Int { get }
    /// Count the number of foreground transitions in the current session.
    @objc
    var foregroundIndex: Int { get }
    /// Pause the session tracking.
    /// Meanwhile the session is paused it can't expire and can't be updated.
    @objc
    func pause()
    /// Resume the session tracking.
    @objc
    func resume()
    /// Expire the current session also if the timeout is not triggered.
    @objc
    func startNewSession()
}
