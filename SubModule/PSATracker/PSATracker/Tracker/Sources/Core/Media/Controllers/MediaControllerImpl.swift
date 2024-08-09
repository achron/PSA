

import Foundation
#if !os(watchOS)
import AVKit
#endif

class MediaControllerImpl: Controller, MediaController {
    
    private var mediaTrackings: [String: MediaTrackingImpl] = [:]
#if !os(watchOS)
    private var playerSubscriptions: [String: AVPlayerSubscription] = [:]
#endif
    
    func startMediaTracking(id: String) -> MediaTracking {
        return startMediaTracking(id: id, player: nil)
    }
    
    func startMediaTracking(id: String, player: MediaPlayerEntity? = nil) -> MediaTracking {
        let configuration = MediaTrackingConfiguration(id: id, player: player)
        return startMediaTracking(configuration: configuration)
    }
    
    func startMediaTracking(configuration: MediaTrackingConfiguration) -> MediaTracking {
        let pingInterval = (
            configuration.pings ? MediaPingInterval(
                pingInterval: configuration.pingInterval,
                maxPausedPings: configuration.maxPausedPings
            ) : nil
        )
        
        let session = (
            configuration.session
            ? MediaSessionTracking(id: configuration.id,
                                   startedAt: nil,
                                   pingInterval: configuration.pingInterval)
            : nil
        )

        let mediaTracking = MediaTrackingImpl(id: configuration.id,
                                              tracker: serviceProvider.trackerController,
                                              player: configuration.player,
                                              session: session,
                                              pingInterval: pingInterval,
                                              boundaries: configuration.boundaries,
                                              captureEvents: configuration.captureEvents,
                                              entities: configuration.entities)
        
        mediaTrackings[configuration.id] = mediaTracking
        
        return mediaTracking
    }
    
#if !os(watchOS)
    func startMediaTracking(player: AVPlayer,
                            configuration: MediaTrackingConfiguration) -> MediaTracking {
        let tracking = startMediaTracking(configuration: configuration)
        
        let subscription = AVPlayerSubscription(player: player, mediaTracking: tracking)
        playerSubscriptions[configuration.id] = subscription
        
        return tracking
    }
#endif
    
    func mediaTracking(id: String) -> MediaTracking? {
        return mediaTrackings[id]
    }
    
    func endMediaTracking(id: String) {
#if !os(watchOS)
        if let subscription = playerSubscriptions[id] {
            subscription.unsubscribe()
            playerSubscriptions.removeValue(forKey: id)
        }
#endif
        
        if let tracking = mediaTrackings[id] {
            tracking.end()
            mediaTrackings.removeValue(forKey: id)
        }
    }
}
