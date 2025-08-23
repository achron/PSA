

import Foundation
@testable import PSATracker

class MockNetworkConnection: NSObject, NetworkConnection {
    var statusCode = 0

    private var _httpMethod: HttpMethodOptions?
    var httpMethod: HttpMethodOptions {
        return _httpMethod!
    }
    var previousResults: [[RequestResult]] = []
    var previousRequests: [[Request]] = []
    var urlEndpoint: URL? {
        return (URL(string: "http://fake-url.com"))!
    }

    var sendingCount: Int {
        return previousResults.count
    }

    init(requestOption httpMethod: HttpMethodOptions, statusCode: Int) {
        super.init()
        self._httpMethod = httpMethod
        self.statusCode = statusCode
    }

    func sendRequests(_ requests: [Request]) -> [RequestResult] {
        var requestResults: [RequestResult] = []
        for request in requests {
            let result = RequestResult(statusCode: NSNumber(value: statusCode), oversize: request.oversize, storeIds: request.emitterEventIds)
            logVerbose(message: "Sent \(String(describing: request.emitterEventIds)) with success \(result.isSuccessful ? "YES" : "NO")")
            requestResults.append(result)
        }
        previousRequests.append(requests)
        previousResults.append(requestResults)
        return requestResults
    }
}
