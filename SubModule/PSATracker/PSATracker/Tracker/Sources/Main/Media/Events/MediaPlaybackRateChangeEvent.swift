

import Foundation

/**
 Media player event sent when the playback rate has changed.
 */
@objc(SPMediaPlaybackRateChangeEvent)
public class MediaPlaybackRateChangeEvent: SelfDescribingAbstract, MediaPlayerUpdatingEvent {
    
    /// Playback rate before the change (1 is normal)
    /// If not set, the previous rate is taken from the last setting in media player.
    public var previousRate: Double?
    
    /// Playback rate after the change (1 is normal)
    @objc
    public var newRate: Double
    
    override var schema: String {
        return MediaSchemata.eventSchema("playback_rate_change")
    }
    
    override var payload: [String : Any] {
        var data: [String : Any] = ["newRate": newRate]
        if let previousRate = previousRate { data["previousRate"] = previousRate }
        return data
    }
    
    /// - Parameter previousRate: Playback rate before the change (1 is normal). If not set, it is taken from the last setting in media player.
    /// - Parameter newRate: Playback rate after the change (1 is normal)
    init(previousRate: Double? = nil, newRate: Double) {
        self.previousRate = previousRate
        self.newRate = newRate
    }
    
    /// - Parameter newRate: Playback rate after the change (1 is normal)
    @objc
    init(newRate: Double) {
        self.newRate = newRate
    }
    
    /// Playback rate before the change (1 is normal)
    /// If not set, the previous rate is taken from the last setting in media player.
    @objc
    public func previousRate(_ previousRate: Double) -> Self {
        self.previousRate = previousRate
        return self
    }
    
    /// Playback rate after the change (1 is normal)
    @objc
    public func newRate(_ newRate: Double) -> Self {
        self.newRate = newRate
        return self
    }
    
    func update(player: MediaPlayerEntity) {
        if previousRate == nil {
            if let previousRate = player.playbackRate {
                self.previousRate = previousRate
            }
        }
        player.playbackRate = newRate
    }
}
