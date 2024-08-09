

import Foundation

/**
 Media player event fired when the player goes into the buffering state and begins to buffer content.
 */
@objc(SPMediaBufferStartEvent)
public class MediaBufferStartEvent: SelfDescribingAbstract {
    
    override var schema: String {
        return MediaSchemata.eventSchema("buffer_start")
    }
    
    override var payload: [String : Any] {
        return [:]
    }
}
