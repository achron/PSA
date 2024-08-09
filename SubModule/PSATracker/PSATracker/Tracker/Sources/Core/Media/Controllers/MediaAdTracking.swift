

import Foundation

class MediaAdTracking {
    var ad: MediaAdEntity?
    var adBreak: MediaAdBreakEntity?
    private var podPosition = 0
    
    var entities: [SelfDescribingJson] {
        var entities: [SelfDescribingJson] = []
        if let entity = self.adBreak?.entity { entities.append(entity) }
        if let entity = self.ad?.entity { entities.append(entity) }
        return entities
    }
    
    func updateForThisEvent(event: Event?, player: MediaPlayerEntity, ad: MediaAdEntity?, adBreak: MediaAdBreakEntity?) {
        switch (event) {
        case is MediaAdStartEvent:
            self.ad = nil
            self.podPosition += 1
        case is MediaAdBreakStartEvent:
            self.adBreak = nil
            self.podPosition = 0
        default: break
        }
        
        if let ad = ad {
            self.ad?.update(from: ad)
            self.ad = self.ad ?? ad
            if podPosition > 0 { self.ad?.podPosition = podPosition }
        }
        
        if let adBreak = adBreak {
            self.adBreak?.update(adBreak: adBreak)
            self.adBreak = self.adBreak ?? adBreak
            self.adBreak?.update(player: player)
        }
    }
    
    func updateForNextEvent(event: Event?) {
        switch (event) {
        case is MediaAdBreakEndEvent:
            self.adBreak = nil
            self.podPosition = 0
        case is MediaAdCompleteEvent, is MediaAdSkipEvent:
            self.ad = nil
        default: break
        }
    }
}
