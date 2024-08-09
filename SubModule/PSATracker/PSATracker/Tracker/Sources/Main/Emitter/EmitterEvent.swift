

import Foundation

@objc(SPEmitterEvent)
public class EmitterEvent: NSObject {
    private(set) var payload: Payload
    private(set) var storeId: Int64

    init(payload: Payload, storeId: Int64) {
        self.payload = payload
        self.storeId = storeId
    }

    @objc
    override public var description: String {
        return String(format: "EmitterEvent{ %lld }", storeId)
    }
}
