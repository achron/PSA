

import Foundation
import XCTest
@testable import PSATracker

#if canImport(SwiftUI)
#if os(iOS) || os(tvOS) || os(macOS)

class TestScreenViewModifier: XCTestCase {
    func testTracksScreenViewWithContextEntity() {
        if #available(iOS 13.0, macOS 10.15, macCatalyst 13.0, tvOS 13.0, *) {
            let expect = expectation(description: "Event received")
            createTracker { event in
                XCTAssertEqual("screen-1", event.payload["name"] as? String)
                XCTAssertEqual(kSPScreenViewSchema, event.schema)
                XCTAssertTrue(
                    event.entities.filter({ entity in
                        entity.schema == "iglu:com.snowplowanalytics.iglu/anything-a/jsonschema/1-0-0"
                    }).count == 1
                )
                expect.fulfill()
            }

            let modifier = ScreenViewModifier(
                name: "screen-1",
                entities: [
                    (
                        schema: "iglu:com.snowplowanalytics.iglu/anything-a/jsonschema/1-0-0",
                        data: [
                            "works": true
                        ]
                    )
                ],
                trackerNamespace: "screenViewTracker"
            )
            modifier.trackScreenView()

            wait(for: [expect], timeout: 1)
        }
    }
    
    private func createTracker(afterTrack: @escaping (InspectableEvent) -> ()) {
        let networkConfig = NetworkConfiguration(networkConnection: MockNetworkConnection(requestOption: .post, statusCode: 200))
        
        _ = PSATracker.createTracker(
            namespace: "screenViewTracker",
            network: networkConfig,
            configurations: [
                PluginConfiguration(identifier: "screenViewPlugin")
                    .afterTrack(closure: afterTrack),
                TrackerConfiguration()
                    .installAutotracking(false)
                    .lifecycleAutotracking(false)
            ])
    }
}

private struct ScreenViewExpected: Codable {
    let name: String
}

private struct AnythingEntityExpected: Codable {
    let works: Bool
}

#endif
#endif
