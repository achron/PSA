

import Foundation

/** Media player event sent when the user pauses the playback. */
@objc(SPMediaPauseEvent)
public class MediaPauseEvent: SelfDescribingAbstract, MediaPlayerUpdatingEvent {
    
    override var schema: String {
        return MediaSchemata.eventSchema("pause")
    }
    
    override var payload: [String : Any] {
        return [:]
    }
    
    func update(player: MediaPlayerEntity) {
        player.paused = true
    }
}
