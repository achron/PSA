

import Foundation

class MemoryEventStore: NSObject, EventStore {

    var sendLimit: UInt
    var index: Int64
    var orderedSet: NSMutableOrderedSet


    convenience override init() {
        self.init(limit: 250)
    }

    init(limit: UInt) {
        orderedSet = NSMutableOrderedSet()
        sendLimit = limit
        index = 0
    }

    // Interface methods

    func addEvent(_ payload: Payload) {
        objc_sync_enter(self)
        let item = EmitterEvent(payload: payload, storeId: index)
        orderedSet.add(item)
        objc_sync_exit(self)
        index += 1
    }

    func count() -> UInt {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        return UInt(orderedSet.count)
    }

    func emittableEvents(withQueryLimit queryLimit: UInt) -> [EmitterEvent] {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        let setCount = (orderedSet).count
        if setCount <= 0 {
            return []
        }
        let len = min(Int(queryLimit), setCount)
        _ = NSRange(location: 0, length: len)
        var count = 0
        let indexes = orderedSet.indexes { _, _, _ in
            count += 1
            return count <= queryLimit
        }
        let objects = orderedSet.objects(at: indexes)
        var result: [EmitterEvent] = []
        for object in objects {
            if let event = object as? EmitterEvent {
                result.append(event)
            }
        }
        return result
    }

    func removeAllEvents() -> Bool {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        orderedSet.removeAllObjects()
        return true
    }

    func removeEvent(withId storeId: Int64) -> Bool {
        return removeEvents(withIds: [storeId])
    }

    func removeEvents(withIds storeIds: [Int64]) -> Bool {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        var itemsToRemove: [EmitterEvent] = []
        for item in orderedSet {
            guard let item = item as? EmitterEvent else {
                continue
            }
            if storeIds.contains(item.storeId) {
                itemsToRemove.append(item)
            }
        }
        orderedSet.removeObjects(in: itemsToRemove)
        return true
    }
}
