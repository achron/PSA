

import XCTest
@testable import PSATracker

class TestSubject: XCTestCase {
    func testReturnsPlatformContextIfEnabled() {
        let subject = Subject(platformContext: true, geoLocationContext: false)
        let platformDict = subject.platformDict(userAnonymisation: false, advertisingIdentifierRetriever: nil)
        XCTAssertNotNil(platformDict)
        XCTAssertNotNil(platformDict?.dictionary[kSPPlatformOsType])
    }

    func testDoesntReturnPlatformContextIfDisabled() {
        let subject = Subject(platformContext: false, geoLocationContext: false)
        let platformDict = subject.platformDict(userAnonymisation: false, advertisingIdentifierRetriever: nil)
        XCTAssertNil(platformDict)
    }

    func testReturnsGeolocationContextIfEnabled() {
        let subject = Subject(platformContext: false, geoLocationContext: true)
        subject.geoLatitude = NSNumber(value: 10.0)
        subject.geoLongitude = NSNumber(value: 10.0)
        let geoLocationDict = subject.geoLocationDict
        XCTAssertNotNil(geoLocationDict)
        XCTAssertNotNil(geoLocationDict)
    }

    func testDoesntReturnGeolocationContextIfDisabled() {
        let subject = Subject(platformContext: false, geoLocationContext: false)
        subject.geoLatitude = NSNumber(value: 10.0)
        subject.geoLongitude = NSNumber(value: 10.0)
        let geoLocationDict = subject.geoLocationDict
        XCTAssertNil(geoLocationDict)
    }

    func testAnonymisesUserIdentifiers() {
        let subject = Subject(platformContext: false, geoLocationContext: false)
        subject.userId = "aUserId"
        subject.ipAddress = "127.0.0.1"
        subject.networkUserId = "aNuid"
        subject.domainUserId = "aDuid"
        subject.language = "EN"

        let values = subject.standardDict(userAnonymisation: true)
        XCTAssertNil(values[kSPUid])
        XCTAssertNil(values[kSPIpAddress])
        XCTAssertNil(values[kSPNetworkUid])
        XCTAssertNil(values[kSPDomainUid])
        XCTAssertEqual(values[kSPLanguage], "EN")
    }
}
