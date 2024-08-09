

import Foundation

/** Media player event fired immediately after the browser switches into or out of picture-in-picture mode. */
@objc(SPMediaPictureInPictureChangeEvent)
public class MediaPictureInPictureChangeEvent: SelfDescribingAbstract, MediaPlayerUpdatingEvent {
    
    /// Whether the video element is showing picture-in-picture after the change.
    @objc
    public var pictureInPicture: Bool
    
    override var schema: String {
        return MediaSchemata.eventSchema("picture_in_picture_change")
    }
    
    override var payload: [String : Any] {
        return ["pictureInPicture": pictureInPicture]
    }
    
    /// - Parameter pictureInPicture: Whether the video element is showing picture-in-picture after the change.
    @objc
    public init(pictureInPicture: Bool) {
        self.pictureInPicture = pictureInPicture
    }
    
    /// Whether the video element is showing picture-in-picture after the change.
    @objc
    public func pictureInPicture(_ pictureInPicture: Bool) -> Self {
        self.pictureInPicture = pictureInPicture
        return self
    }
    
    func update(player: MediaPlayerEntity) {
        player.pictureInPicture = pictureInPicture
    }
}
