

import XCTest
@testable import PSATracker

class TestEmitterConfiguration: XCTestCase {
    override func setUp() {
        super.setUp()
        Logger.logLevel = .verbose
    }

    override func tearDown() {
        PSATracker.removeAllTrackers()
        super.tearDown()
    }

    func testPauseEmitter() {
        let networkConnection = MockNetworkConnection(requestOption: .post, statusCode: 200)
        let emitterConfig = EmitterConfiguration()
        emitterConfig.eventStore = MockEventStore()
        emitterConfig.bufferOption = .single
        let networkConfig = NetworkConfiguration(networkConnection: networkConnection)

        let tracker = createTracker(networkConfig: networkConfig, emitterConfig: emitterConfig)

        tracker.emitter?.pause()
        _ = tracker.track(Structured(category: "cat", action: "act"))
        Thread.sleep(forTimeInterval: 1)
        XCTAssertEqual(1, tracker.emitter?.dbCount)
        XCTAssertEqual(0, networkConnection.previousResults.count)

        tracker.emitter?.resume()
        Thread.sleep(forTimeInterval: 1)
        XCTAssertEqual(1, networkConnection.previousResults.count)
        XCTAssertEqual(0, tracker.emitter?.dbCount)
    }

    func testActivatesServerAnonymisationInEmitter() {
        let emitterConfig = EmitterConfiguration()
        emitterConfig.serverAnonymisation = true

        let networkConfig = NetworkConfiguration(endpoint: "", method: .post)

        let tracker = createTracker(networkConfig: networkConfig, emitterConfig: emitterConfig)

        XCTAssertTrue(tracker.emitter?.serverAnonymisation ?? false)
    }
    
    func testRespectsEmitRange() {
        let networkConnection = MockNetworkConnection(requestOption: .post, statusCode: 200)
        let emitterConfig = EmitterConfiguration()
        emitterConfig.eventStore = MockEventStore()
        emitterConfig.emitRange = 2
        let networkConfig = NetworkConfiguration(networkConnection: networkConnection)

        let tracker = createTracker(networkConfig: networkConfig, emitterConfig: emitterConfig)

        tracker.emitter?.pause()
        for i in 0..<10 {
            _ = tracker.track(Structured(category: "cat", action: "act").value(NSNumber(value: i)))
        }
        Thread.sleep(forTimeInterval: 1)
        XCTAssertEqual(10, tracker.emitter?.dbCount)
        XCTAssertEqual(0, networkConnection.previousResults.count)

        tracker.emitter?.resume()
        Thread.sleep(forTimeInterval: 1)
        XCTAssertEqual(5, networkConnection.previousResults.count) // 5 requests for 10 events – emit range 2
        XCTAssertEqual(0, tracker.emitter?.dbCount)
    }
    
    private func createTracker(networkConfig: NetworkConfiguration, emitterConfig: EmitterConfiguration) -> TrackerController {
        let trackerConfig = TrackerConfiguration()
        trackerConfig.installAutotracking = false
        trackerConfig.screenViewAutotracking = false
        trackerConfig.lifecycleAutotracking = false
        let namespace = "testEmitter" + String(describing: Int.random(in: 0..<100))
        return PSATracker.createTracker(namespace: namespace,
                                      network: networkConfig,
                                      configurations: [trackerConfig, emitterConfig])!
    }
    
}
