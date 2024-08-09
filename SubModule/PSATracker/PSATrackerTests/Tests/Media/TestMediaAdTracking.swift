

import XCTest
@testable import PSATracker

class TestMediaAdTracking: XCTestCase {
    
    func testUpdatesStartTimeOfAdBreak() {
        let adTracking = MediaAdTracking()
        
        adTracking.updateForThisEvent(event: MediaAdBreakStartEvent(),
                                      player: MediaPlayerEntity().currentTime(33.0),
                                      ad: nil,
                                      adBreak: MediaAdBreakEntity(breakId: "b1"))
        adTracking.updateForNextEvent(event: MediaAdBreakStartEvent())
        
        adTracking.updateForThisEvent(event: MediaAdStartEvent(),
                                      player: MediaPlayerEntity().currentTime(44.0),
                                      ad: MediaAdEntity(adId: "a1"),
                                      adBreak: nil)
        adTracking.updateForNextEvent(event: MediaAdStartEvent())
        
        XCTAssertEqual("b1", adTracking.adBreak?.breakId)
        XCTAssertEqual(33.0, adTracking.adBreak?.startTime)
    }
    
    func testUpdatesPodPositionOfAds() {
        let adTracking = MediaAdTracking()
        
        adTracking.updateForThisEvent(event: MediaAdBreakStartEvent(),
                                      player: MediaPlayerEntity(),
                                      ad: nil,
                                      adBreak: MediaAdBreakEntity(breakId: "b1"))
        adTracking.updateForNextEvent(event: MediaAdBreakStartEvent())
        
        adTracking.updateForThisEvent(event: MediaAdStartEvent(),
                                      player: MediaPlayerEntity(),
                                      ad: MediaAdEntity(adId: "a1"),
                                      adBreak: nil)
        
        XCTAssertEqual(1, adTracking.ad?.podPosition)
        
        adTracking.updateForNextEvent(event: MediaAdStartEvent())
        
        adTracking.updateForThisEvent(event: MediaAdStartEvent(),
                                      player: MediaPlayerEntity(),
                                      ad: MediaAdEntity(adId: "a2"),
                                      adBreak: nil)
        
        XCTAssertEqual(2, adTracking.ad?.podPosition)
    }
}
