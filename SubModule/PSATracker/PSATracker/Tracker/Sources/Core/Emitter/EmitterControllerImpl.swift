

import Foundation

class EmitterControllerImpl: Controller, EmitterController {

    // MARK: - Properties

    var bufferOption: BufferOption {
        get {
            return emitter.bufferOption
        }
        set {
            dirtyConfig.bufferOption = newValue
            emitter.bufferOption = newValue
        }
    }

    var byteLimitGet: Int {
        get {
            return emitter.byteLimitGet
        }
        set {
            dirtyConfig.byteLimitGet = newValue
            emitter.byteLimitGet = newValue
        }
    }

    var byteLimitPost: Int {
        get {
            return emitter.byteLimitPost
        }
        set {
            dirtyConfig.byteLimitPost = newValue
            emitter.byteLimitPost = newValue
        }
    }

    var serverAnonymisation: Bool {
        get {
            return emitter.serverAnonymisation
        }
        set {
            dirtyConfig.serverAnonymisation = newValue
            emitter.serverAnonymisation = newValue
        }
    }

    var emitRange: Int {
        get {
            return emitter.emitRange
        }
        set {
            dirtyConfig.emitRange = newValue
            emitter.emitRange = newValue
        }
    }

    var threadPoolSize: Int {
        get {
            return emitter.emitThreadPoolSize
        }
        set {
            dirtyConfig.threadPoolSize = newValue
            emitter.emitThreadPoolSize = newValue
        }
    }

    private var _requestCallback: RequestCallback?
    var requestCallback: RequestCallback? {
        get {
            return _requestCallback
        }
        set {
            _requestCallback = newValue
            emitter.callback = newValue
        }
    }

    var dbCount: Int {
        return Int(emitter.dbCount)
    }

    var isSending: Bool {
        return emitter.isSending
    }
    
    var customRetryForStatusCodes: [Int : Bool]? {
        get {
            return emitter.customRetryForStatusCodes
        }
        set {
            dirtyConfig.customRetryForStatusCodes = newValue
            emitter.customRetryForStatusCodes = newValue
        }
    }
    
    var retryFailedRequests: Bool {
        get {
            return emitter.retryFailedRequests
        }
        set {
            dirtyConfig.retryFailedRequests = newValue
            emitter.retryFailedRequests = newValue
        }
    }

    // MARK: - Methods

    func flush() {
        emitter.flush()
    }

    func pause() {
        dirtyConfig.isPaused = true
        emitter.pauseEmit()
    }

    func resume() {
        dirtyConfig.isPaused = false
        emitter.resumeEmit()
    }

    // MARK: - Private methods

    private var emitter: Emitter {
        return serviceProvider.tracker.emitter
    }

    private var dirtyConfig: EmitterConfiguration {
        return serviceProvider.emitterConfiguration
    }
}
