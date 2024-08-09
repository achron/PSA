

import XCTest
@testable import PSATracker

class TestLifecycleState: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testLifecycleStateMachine() {
        let eventStore = MockEventStore()
        let emitter = Emitter(urlEndpoint: "http://snowplow-fake-url.com") { emitter in
            emitter.eventStore = eventStore
        }
        let tracker = Tracker(trackerNamespace: "namespace", appId: nil, emitter: emitter) { tracker in
            tracker.base64Encoded = false
            tracker.lifecycleEvents = true
        }

        // Send events
        _ = tracker.track(Timing(category: "category", variable: "variable", timing: 123))
        Thread.sleep(forTimeInterval: 1)
        if eventStore.lastInsertedRow == -1 {
            XCTFail()
        }
        var payload = eventStore.db[Int64(eventStore.lastInsertedRow)]
        _ = eventStore.removeAllEvents()
        var entities = (payload?["co"]) as? String
        XCTAssertNotNil(entities)
        XCTAssertTrue(entities!.contains("\"isVisible\":true"))

        _ = tracker.track(Background(index: 1))
        Thread.sleep(forTimeInterval: 1)
        if eventStore.lastInsertedRow == -1 {
            XCTFail()
        }
        payload = eventStore.db[Int64(eventStore.lastInsertedRow)]
        _ = eventStore.removeAllEvents()
        entities = (payload?["co"]) as? String
        XCTAssertNotNil(entities)
        XCTAssertTrue(entities!.contains("\"isVisible\":false"))

        _ = tracker.track(Timing(category: "category", variable: "variable", timing: 123))
        Thread.sleep(forTimeInterval: 1)
        if eventStore.lastInsertedRow == -1 {
            XCTFail()
        }
        payload = eventStore.db[Int64(eventStore.lastInsertedRow)]
        _ = eventStore.removeAllEvents()
        entities = (payload?["co"]) as? String
        XCTAssertTrue(entities!.contains("\"isVisible\":false"))

        _ = tracker.track(Foreground(index: 1))
        Thread.sleep(forTimeInterval: 1)
        if eventStore.lastInsertedRow == -1 {
            XCTFail()
        }
        payload = eventStore.db[Int64(eventStore.lastInsertedRow)]
        _ = eventStore.removeAllEvents()
        entities = (payload?["co"]) as? String
        XCTAssertNotNil(entities)
        XCTAssertTrue(entities!.contains("\"isVisible\":true"))

        let uuid = UUID()
        _ = tracker.track(ScreenView(name: "screen1", screenId: uuid))
        Thread.sleep(forTimeInterval: 1)
        if eventStore.lastInsertedRow == -1 {
            XCTFail()
        }
        payload = eventStore.db[Int64(eventStore.lastInsertedRow)]
        _ = eventStore.removeAllEvents()
        entities = (payload?["co"]) as? String
        XCTAssertNotNil(entities)
        XCTAssertTrue(entities!.contains("\"isVisible\":true"))
    }
}
