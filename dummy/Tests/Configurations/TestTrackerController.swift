

import XCTest
@testable import PSATracker

class TestTrackerController: XCTestCase {
    func testSessionAccessibilityWhenEnabledAndDisabled() {
        let tracker = PSATracker.createTracker(namespace: "namespace", endpoint: "https://fake-url", method: .post)
        XCTAssertNotNil(tracker?.session)

        tracker?.sessionContext = false
        XCTAssertNil(tracker?.session)
    }

    func testSubjectUserIdCanBeUpdated() {
        let tracker = PSATracker.createTracker(namespace: "namespace", endpoint: "https://fake-url", method: .post)
        XCTAssertNotNil(tracker?.subject)
        XCTAssertNil(tracker?.subject?.userId)
        tracker?.subject?.userId = "fakeUserId"
        XCTAssertEqual("fakeUserId", tracker?.subject?.userId)
        tracker?.subject?.userId = nil
        XCTAssertNil(tracker?.subject?.userId)
    }

    func testSubjectGeoLocationCanBeUpdated() {
        let tracker = PSATracker.createTracker(namespace: "namespace", endpoint: "https://fake-url", method: .post)
        XCTAssertNotNil(tracker?.subject)
        XCTAssertNil(tracker?.subject?.geoLatitude)
        tracker?.subject?.geoLatitude = NSNumber(value: 12.3456)
        XCTAssertEqual(NSNumber(value: 12.3456), tracker?.subject?.geoLatitude)
        tracker?.subject?.geoLatitude = nil
        // TODO: On version 3 setting to nil should get back nil.
        // Here it should be nil rather than 0 but it's the way the beneith SPSubject works.
        XCTAssertNil(tracker?.subject?.geoLatitude)
    }

    func testStartsNewSessionWhenChangingAnonymousTracking() {
        let tracker = Snowplow.createTracker(namespace: "n2", endpoint: "https://fake-url", method: .post)
        tracker?.emitter?.pause()

        _ = tracker?.track(Structured(category: "c", action: "a"))
        let sessionIdBefore = tracker?.session?.sessionId

        tracker?.userAnonymisation = true
        _ = tracker?.track(Structured(category: "c", action: "a"))
        let sessionIdAnonymous = tracker?.session?.sessionId

        XCTAssertFalse((sessionIdBefore == sessionIdAnonymous))

        tracker?.userAnonymisation = false
        _ = tracker?.track(Structured(category: "c", action: "a"))
        let sessionIdNotAnonymous = tracker?.session?.sessionId

        XCTAssertFalse((sessionIdAnonymous == sessionIdNotAnonymous))
    }
}
