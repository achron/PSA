

import Foundation

/** Media player event sent when playback stops when end of the media is reached or because no further data is available. */
@objc(SPMediaEndEvent)
public class MediaEndEvent: SelfDescribingAbstract, MediaPlayerUpdatingEvent {
    
    override var schema: String {
        return MediaSchemata.eventSchema("end")
    }
    
    override var payload: [String : Any] {
        return [:]
    }
    
    func update(player: MediaPlayerEntity) {
        player.ended = true
        player.paused = true
    }
}
