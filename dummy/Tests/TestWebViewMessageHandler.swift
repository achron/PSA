

#if os(iOS) || os(macOS)
import XCTest
@testable import PSATracker

class TestWebViewMessageHandler: XCTestCase {
    var webViewMessageHandler: WebViewMessageHandler?
    var networkConnection: MockNetworkConnection?

    override func setUp() {
        webViewMessageHandler = WebViewMessageHandler()
        networkConnection = MockNetworkConnection(requestOption: .post, statusCode: 200)

        let networkConfig = NetworkConfiguration(networkConnection: networkConnection)
        let trackerConfig = TrackerConfiguration()
        trackerConfig.base64Encoding = false
        trackerConfig.sessionContext = false
        trackerConfig.platformContext = false

        PSATracker.removeAllTrackers()
        _ = PSATracker.createTracker(namespace: UUID().uuidString, network: networkConfig, configurations: [trackerConfig])
    }

    override func tearDown() {
        PSATracker.removeAllTrackers()
    }

    func testTracksStructuredEventWithAllProperties() {
        let message = MockWKScriptMessage(
            body: [
                "command": "trackStructEvent",
                "event": [
                "category": "cat",
                "action": "act",
                "label": "lbl",
                "property": "prop",
                "value": NSNumber(value: 10.0)
            ]
            ])
        webViewMessageHandler?.receivedMesssage(message)

        for _ in 0..<10 {
            Thread.sleep(forTimeInterval: 0.5)
        }

        XCTAssertEqual(1, networkConnection?.sendingCount)
        XCTAssertEqual(1, (networkConnection?.previousRequests)?[0].count)
        let request = (networkConnection?.previousRequests)?[0][0]
        let payload = (request?.payload?["data"] as? [[String: Any]])?[0]
        XCTAssert((payload?["se_ca"] as? String == "cat"))
        XCTAssert((payload?["se_ac"] as? String == "act"))
        XCTAssert((payload?["se_pr"] as? String == "prop"))
        XCTAssert((payload?["se_la"] as? String == "lbl"))
        XCTAssert((payload?["se_va"] as? String == "10"))
    }

    func testTracksEventWithCorrectTracker() {
        // create the second tracker
        let networkConnection2 = MockNetworkConnection(requestOption: .post, statusCode: 200)
        let networkConfig = NetworkConfiguration(networkConnection: networkConnection2)
        _ = PSATracker.createTracker(namespace: "ns2", network: networkConfig, configurations: [])

        // track an event using the second tracker
        let message = MockWKScriptMessage(
            body: [
                "command": "trackPageView",
                "event": [
                    "url": "http://localhost"
                ],
                "trackers": ["ns2"]
            ])
        webViewMessageHandler?.receivedMesssage(message)

        // wait and check for the event
        for _ in 0..<10 {
            Thread.sleep(forTimeInterval: 0.5)
        }

        XCTAssertEqual(0, networkConnection?.sendingCount)
        XCTAssertEqual(1, networkConnection2.sendingCount)
        XCTAssertEqual(1, networkConnection2.previousRequests[0].count)
    }

    func testTracksEventWithContext() {
        let message = MockWKScriptMessage(
            body: [
                "command": "trackSelfDescribingEvent",
                "event": [
                    "schema": "http://schema.com",
                    "data": [
                        "key": "val"
                    ]
                ],
                "context": [
                    [
                        "schema": "http://context-schema.com",
                        "data": [
                            "a": "b"
                        ]
                    ]
                ]
            ])
        webViewMessageHandler?.receivedMesssage(message)

        for _ in 0..<10 {
            Thread.sleep(forTimeInterval: 0.5)
        }

        XCTAssertEqual(1, networkConnection?.sendingCount)
        XCTAssertEqual(1, (networkConnection?.previousRequests)?[0].count)
        let request = (networkConnection?.previousRequests)?[0][0]
        let payload = (request?.payload?["data"] as? [[String : Any]])?[0]

        let context = payload?["co"] as? String
        XCTAssert(context?.contains("{\"a\":\"b\"}") ?? false)
    }
}
#endif
