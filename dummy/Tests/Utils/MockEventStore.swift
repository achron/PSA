

import Foundation
@testable import PSATracker

class MockEventStore: NSObject, EventStore {
    
    var db: [Int64 : Payload] = [:]
    var lastInsertedRow = 0

    override init() {
        super.init()
        db = [:]
        lastInsertedRow = -1
    }

    func addEvent(_ payload: Payload) {
        objc_sync_enter(self)
        lastInsertedRow += 1
        logVerbose(message: "Add \(payload)")
        db[Int64(lastInsertedRow)] = payload
        objc_sync_exit(self)
    }

    func removeEvent(withId storeId: Int64) -> Bool {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        logVerbose(message: "Remove \(storeId)")
        return db.removeValue(forKey: storeId) != nil
    }

    func removeEvents(withIds storeIds: [Int64]) -> Bool {
        let result = true
        for storeId in storeIds {
            db.removeValue(forKey: storeId)
        }
        return result
    }

    func removeAllEvents() -> Bool {
        objc_sync_enter(self)
        db.removeAll()
        lastInsertedRow = -1
        objc_sync_exit(self)
        return true
    }

    func count() -> UInt {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        return UInt(db.count)
    }

    func emittableEvents(withQueryLimit queryLimit: UInt) -> [EmitterEvent] {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        var eventIds: [Int64] = []
        var events: [EmitterEvent] = []
        for (key, obj) in db {
            let payloadCopy = Payload(dictionary: obj.dictionary)
            let event = EmitterEvent(payload: payloadCopy, storeId: key)
            events.append(event)
            eventIds.append(event.storeId)
        }
        if queryLimit < events.count {
            events = Array(events.prefix(Int(queryLimit)))
        }
        logVerbose(message: "emittableEventsWithQueryLimit: \(eventIds)")
        return events
    }
}
