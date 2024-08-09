

import Foundation

@objc(SPRequest)
public class Request: NSObject {
    @objc
    public private(set) var payload: Payload?
    @objc
    public private(set) var emitterEventIds: [Int64]
    @objc
    public private(set) var oversize = false
    @objc
    public private(set) var customUserAgent: String?

    convenience init(payload: Payload, emitterEventId: Int64) {
        self.init(payload: payload, emitterEventId: emitterEventId, oversize: false)
    }

    init(payload: Payload, emitterEventId: Int64, oversize: Bool) {
        emitterEventIds = [emitterEventId]
        super.init()
        self.payload = payload
        customUserAgent = userAgent(from: payload)
        self.oversize = oversize
    }

    init(payloads: [Payload], emitterEventIds: [Int64]) {
        self.emitterEventIds = emitterEventIds
        super.init()
        var tempUserAgent: String? = nil
        var payloadData: [[String : Any]] = []
        for payload in payloads {
            payloadData.append(payload.dictionary)
            tempUserAgent = userAgent(from: payload)
        }
        let payloadBundle = SelfDescribingJson.dictionary(schema: kSPPayloadDataSchema,
                                                          data: payloadData)
        payload = Payload(dictionary: payloadBundle)
        customUserAgent = tempUserAgent
        oversize = false
    }

    func userAgent(from payload: Payload) -> String? {
        return (payload.dictionary[kSPUseragent] as? String)
    }
}
