

import XCTest
@testable import PSATracker

class TestSelfDescribingJson: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testInitWithObject() {
        let expected: [String : Any] = [
            "schema": "iglu:acme.com/test_event/jsonschema/1-0-0",
            "data": [
                "hello": "world"
            ]
        ]
        let data = [
            "hello": "world"
        ]
        let sdj = SelfDescribingJson(
            schema: "iglu:acme.com/test_event/jsonschema/1-0-0",
            andDictionary: data)
        XCTAssertEqual(NSDictionary(dictionary: expected),
                       NSDictionary(dictionary: sdj.dictionary))
    }

    func testInitWithSPPayload() {
        let expected: [String : Any] = [
            "schema": "iglu:acme.com/test_event/jsonschema/1-0-0",
            "data": [
                "hello": "world"
            ]
        ]
        let data = Payload()
        data.addValueToPayload("world", forKey: "hello")
        let sdj = SelfDescribingJson(
            schema: "iglu:acme.com/test_event/jsonschema/1-0-0",
            andPayload: data)
        XCTAssertEqual(NSDictionary(dictionary: expected),
                       NSDictionary(dictionary: sdj.dictionary))
    }

    func testInitWithSPSelfDescribingJson() {
        let expected: [String : Any] = [
            "schema": "iglu:acme.com/test_event/jsonschema/1-0-0",
            "data": [
                "schema": "iglu:acme.com/nested_event/jsonschema/1-0-0",
                "data": [
                    "hello": "world"
                ]
            ]
        ]
        let nestedData = [
            "hello": "world"
        ]
        let data = SelfDescribingJson(
            schema: "iglu:acme.com/nested_event/jsonschema/1-0-0",
            andDictionary: nestedData)
        let sdj = SelfDescribingJson(
            schema: "iglu:acme.com/test_event/jsonschema/1-0-0",
            andSelfDescribingJson: data)
        XCTAssertEqual(NSDictionary(dictionary: expected),
                       NSDictionary(dictionary: sdj.dictionary))
    }

    func testUpdateSchema() {
        let expected: [String : Any] = [
            "schema": "iglu:acme.com/test_event_2/jsonschema/1-0-0",
            "data": [
                "hello": "world"
            ]
        ]
        let data = [
            "hello": "world"
        ]
        let sdj = SelfDescribingJson(
            schema: "iglu:acme.com/test_event/jsonschema/1-0-0",
            andDictionary: data)
        sdj.schema = "iglu:acme.com/test_event_2/jsonschema/1-0-0"
        XCTAssertEqual(NSDictionary(dictionary: expected),
                       NSDictionary(dictionary: sdj.dictionary))
    }

    func testUpdateDataWithObject() {
        let expected: [String : Any] = [
            "schema": "iglu:acme.com/test_event/jsonschema/1-0-0",
            "data": [
                "world": "hello"
            ]
        ]
        let sdj = SelfDescribingJson(
            schema: "iglu:acme.com/test_event/jsonschema/1-0-0",
            andDictionary: [
                "hello": "world"
            ])
        sdj.data = [
            "world": "hello"
        ]
        XCTAssertEqual(NSDictionary(dictionary: expected),
                       NSDictionary(dictionary: sdj.dictionary))
    }

    func testUpdateDataWithSPPayload() {
        let expected: [String : Any] = [
            "schema": "iglu:acme.com/test_event/jsonschema/1-0-0",
            "data": [
                "world": "hello"
            ]
        ]
        let data = Payload()
        data.addValueToPayload("hello", forKey: "world")
        let sdj = SelfDescribingJson(
            schema: "iglu:acme.com/test_event/jsonschema/1-0-0",
            andDictionary: [
                "hello": "world"
            ])
        sdj.setData(withPayload: data)
        XCTAssertEqual(NSDictionary(dictionary: expected),
                       NSDictionary(dictionary: sdj.dictionary))
    }

    func testUpdateDataWithSPSelfDescribingJson() {
        let expected: [String : Any] = [
            "schema": "iglu:acme.com/test_event/jsonschema/1-0-0",
            "data": [
                "schema": "iglu:acme.com/nested_event/jsonschema/1-0-0",
                "data": [
                    "hello": "world"
                ]
            ]
        ]
        let nestedData = [
            "hello": "world"
        ]
        let data = SelfDescribingJson(
            schema: "iglu:acme.com/nested_event/jsonschema/1-0-0",
            andDictionary: nestedData)
        let sdj = SelfDescribingJson(
            schema: "iglu:acme.com/test_event/jsonschema/1-0-0",
            andDictionary: [
                "hello": "world"
            ])
        sdj.setData(withSelfDescribingJson: data)
        XCTAssertEqual(NSDictionary(dictionary: expected),
                       NSDictionary(dictionary: sdj.dictionary))
    }
}

