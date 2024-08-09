

import Foundation

class SessionControllerImpl: Controller, SessionController {
    var isEnabled: Bool {
        return session != nil
    }

    func pause() {
        dirtyConfig.isPaused = true
        session?.stopChecker()
    }

    func resume() {
        dirtyConfig.isPaused = false
        session?.startChecker()
    }

    func startNewSession() {
        session?.startNewSession()
    }

    // MARK: - Properties

    var foregroundTimeout: Measurement<UnitDuration> {
        get {
            return Measurement(value: Double(foregroundTimeoutInSeconds), unit: .seconds)
        }
        set {
            let foreground = newValue.converted(to: .seconds)
            foregroundTimeoutInSeconds = Int(foreground.value)
        }
    }

    var foregroundTimeoutInSeconds: Int {
        get {
            if let session = session {
                if isEnabled {
                    return Int(session.foregroundTimeout / 1000)
                } else {
                    logDiagnostic(message: "Attempt to access SessionController fields when disabled")
                }
            }
            return -1
        }
        set {
            dirtyConfig.foregroundTimeoutInSeconds = newValue
            session?.foregroundTimeout = newValue * 1000
        }
    }

    var backgroundTimeout: Measurement<UnitDuration> {
        get {
            return Measurement(value: Double(backgroundTimeoutInSeconds), unit: .seconds)
        }
        set {
            let background = newValue.converted(to: .seconds)
            backgroundTimeoutInSeconds = Int(background.value)
        }
    }

    var backgroundTimeoutInSeconds: Int {
        get {
            if let session = session {
                if isEnabled {
                    return Int(session.backgroundTimeout / 1000)
                } else {
                    logDiagnostic(message: "Attempt to access SessionController fields when disabled")
                }
            }
            return -1
        }
        set {
            dirtyConfig.backgroundTimeoutInSeconds = newValue
            session?.backgroundTimeout = newValue * 1000
        }
    }

    var onSessionStateUpdate: ((_ sessionState: SessionState) -> Void)? {
        get {
            if !isEnabled {
                logDiagnostic(message: "Attempt to access SessionController fields when disabled")
                return nil
            }
            return session?.onSessionStateUpdate
        }
        set {
            dirtyConfig.onSessionStateUpdate = newValue
            session?.onSessionStateUpdate = newValue
        }
    }

    var sessionIndex: Int {
        if !isEnabled {
            logDiagnostic(message: "Attempt to access SessionController fields when disabled")
            return -1
        }
        return session?.state?.sessionIndex ?? -1
    }

    var sessionId: String? {
        if !isEnabled {
            logDiagnostic(message: "Attempt to access SessionController fields when disabled")
            return nil
        }
        return session?.state?.sessionId
    }

    var userId: String? {
        if !isEnabled {
            logDiagnostic(message: "Attempt to access SessionController fields when disabled")
            return nil
        }
        return session?.userId
    }

    var isInBackground: Bool {
        if !isEnabled {
            logDiagnostic(message: "Attempt to access SessionController fields when disabled")
            return false
        }
        return session?.inBackground ?? false
    }

    var backgroundIndex: Int {
        if !isEnabled {
            logDiagnostic(message: "Attempt to access SessionController fields when disabled")
            return -1
        }
        return session?.backgroundIndex ?? -1
    }

    var foregroundIndex: Int {
        if !isEnabled {
            logDiagnostic(message: "Attempt to access SessionController fields when disabled")
            return -1
        }
        return session?.foregroundIndex ?? -1
    }

    // MARK: - Private methods

    private var session: Session? {
        get {
            return serviceProvider.tracker.session
        }
    }

    private var dirtyConfig: SessionConfiguration {
        get {
            return serviceProvider.sessionConfiguration
        }
    }
}
