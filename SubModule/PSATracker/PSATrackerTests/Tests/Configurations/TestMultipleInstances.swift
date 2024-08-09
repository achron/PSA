

import XCTest
@testable import PSATracker

class TestMultipleInstances: XCTestCase {
    override func setUp() {
        PSATracker.removeAllTrackers()
    }

    override func tearDown() {
        PSATracker.removeAllTrackers()
    }

    func testSingleInstanceIsReconfigurable() {
        let t1 = PSATracker.createTracker(namespace: "t1", network: NetworkConfiguration(endpoint: "snowplowanalytics.fake"))
        XCTAssertEqual(t1?.network?.endpoint, "https://snowplowanalytics.fake/com.snowplowanalytics.snowplow/tp2")
        let t2 = PSATracker.createTracker(namespace: "t1", network: NetworkConfiguration(endpoint: "snowplowanalytics.fake2"))
        XCTAssertEqual(t2?.network?.endpoint, "https://snowplowanalytics.fake2/com.snowplowanalytics.snowplow/tp2")
        XCTAssertEqual(["t1"], PSATracker.instancedTrackerNamespaces)
        XCTAssertTrue(t1 === t2)
    }

    func testMultipleInstances() {
        let t1 = Snowplow.createTracker(namespace: "t1", network: NetworkConfiguration(endpoint: "snowplowanalytics.fake"))
        XCTAssertEqual(t1?.network?.endpoint, "https://snowplowanalytics.fake/com.snowplowanalytics.snowplow/tp2")
        let t2 = PSATracker.createTracker(namespace: "t2", network: NetworkConfiguration(endpoint: "snowplowanalytics.fake2"))
        XCTAssertEqual(t2?.network?.endpoint, "https://snowplowanalytics.fake2/com.snowplowanalytics.snowplow/tp2")
        XCTAssertFalse(t1 === t2)
        let expectedNamespaces = Set<String>(["t1", "t2"])
        XCTAssertEqual(expectedNamespaces, Set<String>(PSATracker.instancedTrackerNamespaces))
    }

    func testDefaultTracker() {
        let t1 = PSATracker.createTracker(namespace: "t1", network: NetworkConfiguration(endpoint: "snowplowanalytics.fake"))
        _ = PSATracker.createTracker(namespace: "t2", network: NetworkConfiguration(endpoint: "snowplowanalytics.fake2"))
        let td = PSATracker.defaultTracker()
        XCTAssertEqual(t1?.namespace, td?.namespace)
    }

    func testUpdateDefaultTracker() {
        _ = PSATracker.createTracker(namespace: "t1", network: NetworkConfiguration(endpoint: "snowplowanalytics.fake"))
        let t2 = PSATracker.createTracker(namespace: "t2", network: NetworkConfiguration(endpoint: "snowplowanalytics.fake2"))
        _ = PSATracker.setAsDefault(tracker: t2)
        let td = PSATracker.defaultTracker()
        XCTAssertEqual(t2?.namespace, td?.namespace)
    }

    func testRemoveTracker() {
        let t1 = PSATracker.createTracker(namespace: "t1", network: NetworkConfiguration(endpoint: "snowplowanalytics.fake"))
        let t2 = PSATracker.createTracker(namespace: "t2", network: NetworkConfiguration(endpoint: "snowplowanalytics.fake2"))
        _ = Snowplow.remove(tracker: t1)
        XCTAssertNotNil(t2)
        XCTAssertEqual(["t2"], PSATracker.instancedTrackerNamespaces)
    }

    func testRecreateTrackerWhichWasRemovedWithSameNamespace() {
        let t1 = PSATracker.createTracker(namespace: "t1", network: NetworkConfiguration(endpoint: "snowplowanalytics.fake"))
        _ = PSATracker.remove(tracker: t1)
        let t2 = PSATracker.createTracker(namespace: "t1", network: NetworkConfiguration(endpoint: "snowplowanalytics.fake2"))
        XCTAssertFalse(t1 === t2)
        XCTAssertEqual(["t1"], PSATracker.instancedTrackerNamespaces)
    }

    func testRemoveDefaultTracker() {
        let t1 = PSATracker.createTracker(namespace: "t1", network: NetworkConfiguration(endpoint: "snowplowanalytics.fake"))
        _ = PSATracker.remove(tracker: t1)
        let td = PSATracker.defaultTracker()
        XCTAssertNil(td)
        XCTAssertEqual([], PSATracker.instancedTrackerNamespaces)
    }

    func testRemoveAllTrackers() {
        _ = PSATracker.createTracker(namespace: "t1", network: NetworkConfiguration(endpoint: "snowplowanalytics.fake"))
        _ = PSATracker.createTracker(namespace: "t2", network: NetworkConfiguration(endpoint: "snowplowanalytics.fake2"))
        PSATracker.removeAllTrackers()
        XCTAssertEqual([], PSATracker.instancedTrackerNamespaces)
    }
}
