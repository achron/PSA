

import Foundation

public class EmitterDefaults {
    public private(set) static var httpMethod: HttpMethodOptions = .post
    public private(set) static var httpProtocol: ProtocolOptions = .https
    public private(set) static var emitRange = 150
    public private(set) static var emitThreadPoolSize = 15
    public private(set) static var byteLimitGet = 40000
    public private(set) static var byteLimitPost = 40000
    public private(set) static var serverAnonymisation = false
    public private(set) static var bufferOption: BufferOption = .defaultGroup
    public private(set) static var retryFailedRequests = true
}
