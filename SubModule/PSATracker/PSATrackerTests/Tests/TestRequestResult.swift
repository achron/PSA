

import XCTest
@testable import PSATracker

class TestRequestResult: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testSuccessfulRequest() {
        var emitterEventIds: [Int64]? = []
        emitterEventIds?.append(1)
        let result = RequestResult(statusCode: 200, oversize: false, storeIds: emitterEventIds)

        XCTAssertNotNil(result)
        XCTAssertEqual(result.isSuccessful, true)
        XCTAssertEqual(result.shouldRetry([:], retryAllowed: true), false)
        XCTAssertEqual(result.storeIds, emitterEventIds)
    }

    func testFailedRequest() {
        var emitterEventIds: [Int64]? = []
        emitterEventIds?.append(1)
        let result = RequestResult(statusCode: 500, oversize: false, storeIds: emitterEventIds)
        XCTAssertEqual(result.isSuccessful, false)
        XCTAssertEqual(result.shouldRetry([:], retryAllowed: true), true)
    }

    func testDefaultResult() {
        let result = RequestResult()

        XCTAssertNotNil(result)
        XCTAssertEqual(result.isSuccessful, false)
        XCTAssertEqual(result.storeIds?.count, 0)
    }

    func testOversizedFailedRequest() {
        let result = RequestResult(statusCode: 500, oversize: true, storeIds: [])
        XCTAssertEqual(result.isSuccessful, false)
        XCTAssertEqual(result.shouldRetry([:], retryAllowed: true), false)
    }

    func testFailedRequestWithNoRetryStatus() {
        let result = RequestResult(statusCode: 403, oversize: false, storeIds: [])
        XCTAssertEqual(result.isSuccessful, false)
        XCTAssertEqual(result.shouldRetry([:], retryAllowed: true), false)
    }

    func testFailedRequestWithCustomNoRetryStatus() {
        var customRetryRules: [Int : Bool] = [:]
        customRetryRules[403] = true
        customRetryRules[500] = false

        var result = RequestResult(statusCode: 403, oversize: false, storeIds: [])
        XCTAssertEqual(result.shouldRetry(customRetryRules, retryAllowed: true), true)

        result = RequestResult(statusCode: 500, oversize: false, storeIds: [])
        XCTAssertEqual(result.shouldRetry(customRetryRules, retryAllowed: true), false)
    }
    
    func testFailedRequestWithDisabledRetry() {
        let result = RequestResult(statusCode: 500, oversize: false, storeIds: [])
        XCTAssertFalse(result.isSuccessful)
        XCTAssertFalse(result.shouldRetry(nil, retryAllowed: false))
    }
}
