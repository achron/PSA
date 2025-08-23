//
//  TestFocalMeterConfiguration.swift
//  Snowplow-iOSTests
//

import XCTest
import Mocker
@testable import PSATracker

class TestFocalMeterConfiguration: XCTestCase {
    let endpoint = "https://fake-snowplow.io"
    
#if !os(watchOS) && !os(macOS) // Mocker seems not to currently work on watchOS and macOS
    
    override class func setUp() {
        Mocker.removeAll()
    }
    
    override class func tearDown() {
        Mocker.removeAll()
        PSATracker.removeAllTrackers()
        super.tearDown()
    }
    
    func testMakesRequestToKantarEndpointWithUserId() {
        let tracker = createTracker()
        
        let requestExpectation = expectation(description: "Request made")
        mockRequest { query in
            let userId = tracker.session!.userId!
            XCTAssertTrue(query!.contains(userId))
            requestExpectation.fulfill()
        }
        
        _ = tracker.track(Structured(category: "cat", action: "act"))
        wait(for: [requestExpectation], timeout: 1)
    }
    
    func testMakesRequestToKantarEndpointWithProcessedUserId() {
        let configuration = FocalMeterConfiguration(kantarEndpoint: endpoint) { userId in
            return "processed-" + userId
        }
        let tracker = createTracker(configuration)
        
        let requestExpectation = expectation(description: "Request made")
        mockRequest { query in
            let userId = tracker.session!.userId!
            XCTAssertTrue(query!.contains("processed-" + userId))
            requestExpectation.fulfill()
        }
        
        _ = tracker.track(Structured(category: "cat", action: "act"))
        wait(for: [requestExpectation], timeout: 1)
    }
    
    func testMakesRequestToKantarEndpointWhenUserIdChanges() {
        // log queries of requests
        var kantarRequestQueries: [String] = []
        let tracker = createTracker()
        var requestExpectation: XCTestExpectation? = expectation(description: "Anonymous request made")
        mockRequest { query in
            kantarRequestQueries.append(query!)
            requestExpectation?.fulfill()
        }
        
        // enable user anonymisation, should trigger request with anonymous user id
        tracker.userAnonymisation = true
        _ = tracker.track(Structured(category: "cat", action: "act"))
        wait(for: [requestExpectation!], timeout: 1)
        XCTAssertEqual(1, kantarRequestQueries.count)
        XCTAssertTrue(kantarRequestQueries.first!.contains("00000000-0000-0000-0000-000000000000"))
        kantarRequestQueries.removeAll()
        
        // disable user anonymisation, should trigger new request
        requestExpectation = expectation(description: "Second request made")
        tracker.userAnonymisation = false
        _ = tracker.track(ScreenView(name: "sv"))
        wait(for: [requestExpectation!], timeout: 1)
        XCTAssertEqual(1, kantarRequestQueries.count)
        let userId = tracker.session!.userId!
        XCTAssertTrue(kantarRequestQueries.first!.contains(userId))
        kantarRequestQueries.removeAll()
        
        // tracking another should not trigger a request as user ID did not change
        requestExpectation = nil
        _ = tracker.track(Structured(category: "cat", action: "act"))
        let sleep = expectation(description: "Wait for events to be tracked")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { () -> Void in
            sleep.fulfill()
        }
        wait(for: [sleep], timeout: 1)
        XCTAssertEqual(0, kantarRequestQueries.count)
    }
    
    private func mockRequest(callback: @escaping (String?) -> Void) {
        var mock = Mock(url: URL(string: endpoint)!, ignoreQuery: true, dataType: .json, statusCode: 200, data: [
            .get: Data()
        ])
        mock.onRequest = { (request, body) in
            callback(request.url?.query)
        }
        mock.register()
    }
    
    private func createTracker(_ focalMeterConfig: FocalMeterConfiguration? = nil) -> TrackerController {
        let connection = MockNetworkConnection(requestOption: .post, statusCode: 200)
        let networkConfig = NetworkConfiguration(networkConnection: connection)
        let trackerConfig = TrackerConfiguration()
        trackerConfig.installAutotracking = false
        trackerConfig.diagnosticAutotracking = false
        let namespace = "testFocalMeter" + String(describing: Int.random(in: 0..<100))
        return PSATracker.createTracker(namespace: namespace,
                                      network: networkConfig,
                                      configurations: [
                                        trackerConfig,
                                        focalMeterConfig ?? FocalMeterConfiguration(kantarEndpoint: endpoint)
                                      ])!
    }
    
#endif
}
