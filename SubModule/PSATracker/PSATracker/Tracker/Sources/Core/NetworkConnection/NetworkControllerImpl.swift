

import Foundation

class NetworkControllerImpl: Controller, NetworkController {
    private var requestCallback: RequestCallback?

    var isCustomNetworkConnection: Bool {
        return emitter.networkConnection != nil && !(emitter.networkConnection is DefaultNetworkConnection)
    }

    // MARK: - Properties

    var endpoint: String? {
        get {
            return emitter.urlEndpoint
        }
        set {
            emitter.urlEndpoint = newValue
        }
    }

    var method: HttpMethodOptions {
        get {
            return emitter.method
        }
        set {
            emitter.method = newValue
        }
    }

    var customPostPath: String? {
        get {
            return emitter.customPostPath
        }
        set {
            dirtyConfig.customPostPath = newValue
            emitter.customPostPath = newValue
        }
    }

    var requestHeaders: [String : String]? {
        get {
            return emitter.requestHeaders
        }
        set {
            dirtyConfig.requestHeaders = requestHeaders
            emitter.requestHeaders = newValue
        }
    }

    // MARK: - Private methods

    private var emitter: Emitter {
        return serviceProvider.tracker.emitter
    }

    private var dirtyConfig: NetworkConfiguration {
        return serviceProvider.networkConfiguration
    }
}
