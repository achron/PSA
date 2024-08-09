

import Foundation

/**
 Media player event fired when the the player finishes buffering content and resumes playback.
 */
@objc(SPMediaBufferEndEvent)
public class MediaBufferEndEvent: SelfDescribingAbstract {
    
    override var schema: String {
        return MediaSchemata.eventSchema("buffer_end")
    }
    
    override var payload: [String : Any] {
        return [:]
    }
}
