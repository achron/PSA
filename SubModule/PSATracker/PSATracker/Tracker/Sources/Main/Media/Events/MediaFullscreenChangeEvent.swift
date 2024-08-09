

import Foundation

/** Media player event fired immediately after the browser switches into or out of full-screen mode. */
@objc(SPMediaFullscreenChangeEvent)
public class MediaFullscreenChangeEvent: SelfDescribingAbstract, MediaPlayerUpdatingEvent {
    
    /// Whether the video element is fullscreen after the change.
    @objc
    public var fullscreen: Bool
    
    override var schema: String {
        return MediaSchemata.eventSchema("fullscreen_change")
    }
    
    override var payload: [String : Any] {
        return ["fullscreen": fullscreen]
    }
    
    /// - Parameter fullscreen: Whether the video element is fullscreen after the change.
    @objc
    public init(fullscreen: Bool) {
        self.fullscreen = fullscreen
    }
    
    /// Whether the video element is fullscreen after the change.
    @objc
    public func fullscreen(_ fullscreen: Bool) -> Self {
        self.fullscreen = fullscreen
        return self
    }
    
    func update(player: MediaPlayerEntity) {
        player.fullscreen = fullscreen
    }
}
