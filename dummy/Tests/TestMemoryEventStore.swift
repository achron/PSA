

import XCTest
@testable import PSATracker

class TestMemoryEventStore: XCTestCase {
    func testInit() {
        let eventStore = MemoryEventStore()
        XCTAssertNotNil(eventStore)
    }

    func testInsertPayload() {
        let eventStore = MemoryEventStore()
        _ = eventStore.removeAllEvents()

        // Build an event
        let payload = Payload()
        payload.addValueToPayload("pv", forKey: "e")
        payload.addValueToPayload("www.foobar.com", forKey: "url")
        payload.addValueToPayload("Welcome to foobar!", forKey: "page")
        payload.addValueToPayload("MEEEE", forKey: "refr")

        // Insert an event
        eventStore.addEvent(payload)

        XCTAssertEqual(eventStore.count(), 1)
        let events = eventStore.emittableEvents(withQueryLimit: 1)
        XCTAssertEqual(events[0].payload.dictionary as! [String : String],
                       payload.dictionary as! [String : String])
        _ = eventStore.removeEvent(withId: 0)

        XCTAssertEqual(eventStore.count(), 0)
    }

    func testInsertManyPayloads() {
        let eventStore = MemoryEventStore()
        _ = eventStore.removeAllEvents()

        // Build an event
        let payload = Payload()
        payload.addValueToPayload("pv", forKey: "e")
        payload.addValueToPayload("www.foobar.com", forKey: "url")
        payload.addValueToPayload("Welcome to foobar!", forKey: "page")
        payload.addValueToPayload("MEEEE", forKey: "refr")

        for _ in 0..<250 {
            eventStore.addEvent(payload)
        }

        XCTAssertEqual(eventStore.count(), 250)
        XCTAssertEqual(eventStore.emittableEvents(withQueryLimit: 600).count, 250)
        XCTAssertEqual(eventStore.emittableEvents(withQueryLimit: 150).count, 150)

        _ = eventStore.removeAllEvents()
        XCTAssertEqual(eventStore.count(), 0)
    }
}
