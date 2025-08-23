

import XCTest
@testable import PSATracker

class TestConfigurationBuilder: XCTestCase {
#if swift(>=5.4)
    func testCreateTrackerUsingBuilder() {
        let pluginName: String? = "plugin"
        let tracker = PSATracker.createTracker(namespace: "ns",
                                             endpoint: "https://snowplow.io") {
            TrackerConfiguration()
                .installAutotracking(false)
                .exceptionAutotracking(false)
                .appId("app_id")
            
            SubjectConfiguration()
                .domainUserId("xxx")
            
            EmitterConfiguration()
                .threadPoolSize(33)
            
            if let pluginName = pluginName {
                PluginConfiguration(identifier: pluginName)
                    .afterTrack { event in }
            }
        }
        
        XCTAssertEqual("ns", tracker?.namespace)
        XCTAssertEqual("app_id", tracker?.appId)
        XCTAssertTrue(tracker?.network?.endpoint?.starts(with: "https://snowplow.io") ?? false)
        XCTAssertEqual(.post, tracker?.network?.method)
        XCTAssertFalse(tracker!.installAutotracking)
        XCTAssertFalse(tracker!.exceptionAutotracking)
        XCTAssertEqual("xxx", tracker?.subject?.domainUserId)
        XCTAssertEqual(33, tracker?.emitter?.threadPoolSize)
        XCTAssertEqual(["plugin"], tracker?.plugins.identifiers)
    }
#endif
}
