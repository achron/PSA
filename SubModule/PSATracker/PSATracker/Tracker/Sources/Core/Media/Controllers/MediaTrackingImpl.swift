

import Foundation

class MediaTrackingImpl: MediaTracking {
    var id: String

    private var session: MediaSessionTracking?
    private var adTracking = MediaAdTracking()
    private var player = MediaPlayerEntity()
    private var pingInterval: MediaPingInterval?
    private var sentBoundaries: [Int] = []
    private var seeking = false
    private var tracker: TrackerController
    private var captureEvents: [Event.Type]?
    private var customEntities: [SelfDescribingJson]?
    private var boundaries: [Int]?
    
    private var entities: [SelfDescribingJson] {
        var entities = [
            self.player.entity
        ]
        if let entity = self.session?.entity { entities.append(entity) }
        entities += self.adTracking.entities
        if let customEntities = customEntities {
            entities += customEntities
        }
        return entities
    }
    
    init(id: String,
         tracker: TrackerController,
         player: MediaPlayerEntity? = nil,
         session: MediaSessionTracking? = nil,
         pingInterval: MediaPingInterval? = nil,
         boundaries: [Int]? = nil,
         captureEvents: [Event.Type]? = nil,
         entities: [SelfDescribingJson]? = nil,
         dateGenerator: @escaping () -> Date = Date.init) {
        self.id = id
        self.tracker = tracker
        self.boundaries = boundaries
        self.pingInterval = pingInterval
        self.captureEvents = captureEvents
        self.session = session
        self.customEntities = entities
        
        if let player = player {
            self.player.update(from: player)
        }
        
        self.pingInterval?.subscribe {
            self.track(MediaPingEvent())
        }
    }
    
    func end() {
        self.pingInterval?.end()
    }
    
    // MARK: Update methods overloads
    
    func update(player: MediaPlayerEntity?) {
        self.update(event: nil, player: player, ad: nil, adBreak: nil)
    }
    
    func update(player: MediaPlayerEntity?, ad: MediaAdEntity?, adBreak: MediaAdBreakEntity?) {
        self.update(event: nil, player: player, ad: ad, adBreak: adBreak)
    }
    
    // MARK: Track methods overloads
    
    func track(_ event: Event) {
        self.track(event, player: nil, ad: nil, adBreak: nil)
    }
    
    func track(_ event: Event, player: MediaPlayerEntity?) {
        self.track(event, player: player, ad: nil, adBreak: nil)
    }
    
    func track(_ event: Event, ad: MediaAdEntity?) {
        self.track(event, player: nil, ad: ad, adBreak: nil)
    }
    
    func track(_ event: Event, player: MediaPlayerEntity?, ad: MediaAdEntity?) {
        self.track(event, player: player, ad: ad, adBreak: nil)
    }
    
    func track(_ event: Event, adBreak: MediaAdBreakEntity?) {
        self.track(event, player: nil, ad: nil, adBreak: adBreak)
    }
    
    func track(_ event: Event, player: MediaPlayerEntity?, adBreak: MediaAdBreakEntity?) {
        self.track(event, player: player, ad: nil, adBreak: adBreak)
    }
    
    func track(_ event: Event, player: MediaPlayerEntity?, ad: MediaAdEntity?, adBreak: MediaAdBreakEntity?) {
        self.update(event: event, player: player, ad: ad, adBreak: adBreak)
    }
    
    // MARK: Private methods
    
    private func update(event: Event? = nil,
                        player: MediaPlayerEntity? = nil,
                        ad: MediaAdEntity? = nil,
                        adBreak: MediaAdBreakEntity? = nil) {
        objc_sync_enter(self)

        // update state
        if let player = player {
            self.player.update(from: player)
        }
        (event as? MediaPlayerUpdatingEvent)?.update(player: self.player)
        adTracking.updateForThisEvent(event: event,
                                      player: self.player,
                                      ad: ad,
                                      adBreak: adBreak)
        session?.update(event: event,
                        player: self.player,
                        adBreak: adTracking.adBreak)
        pingInterval?.update(player: self.player)
        
        // track events
        if let event = event {
            addEntitiesAndTrack(event: event)
        }
        if shouldSendPercentProgress() {
            addEntitiesAndTrack(event: MediaPercentProgressEvent())
        }
        
        // update state for events after this one
        if let event = event {
            adTracking.updateForNextEvent(event: event)
        }
        
        objc_sync_exit(self)
    }
    
    private func addEntitiesAndTrack(event: Event) {
        guard shouldTrackEvent(event) else { return }
        
        event.entities = event.entities + entities
        
        _ = self.tracker.track(event)
    }
    
    private func shouldSendPercentProgress() -> Bool {
        if player.paused ?? true { return false }
        guard let boundaries = boundaries,
              let percentProgress = player.percentProgress else { return false }
        
        let achievedBoundaries = boundaries.filter { $0 <= percentProgress }
        
        if let boundary = achievedBoundaries.max() {
            if !sentBoundaries.contains(boundary) {
                sentBoundaries.append(boundary)
                return true
            }
        }
        
        return false
    }
    
    private func shouldTrackEvent(_ event: Event) -> Bool {
        if event is MediaSeekStartEvent {
            if seeking {
               return false
            }
            seeking = true
        } else if event is MediaSeekEndEvent {
            seeking = false
        }
        
        if let captureEvents = captureEvents {
            return captureEvents.contains { type(of: event) == $0 }
        }
        
        return true
    }
    
}
