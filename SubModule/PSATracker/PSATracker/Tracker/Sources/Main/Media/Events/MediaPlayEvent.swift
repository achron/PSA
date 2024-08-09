

import Foundation

/** Media player event sent when the player changes state to playing from previously being paused. */
@objc(SPMediaPlayEvent)
public class MediaPlayEvent: SelfDescribingAbstract, MediaPlayerUpdatingEvent {
    
    override var schema: String {
        return MediaSchemata.eventSchema("play")
    }
    
    override var payload: [String : Any] {
        return [:]
    }
    
    func update(player: MediaPlayerEntity) {
        player.paused = false
    }
}
