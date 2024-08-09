

import Foundation

class MediaSessionTracking {
    
    private var session: MediaSessionEntity
    private var stats: MediaSessionTrackingStats
    
    var entity: SelfDescribingJson {
        return session.entity(stats: stats)
    }
    
    init(id: String,
         startedAt: Date? = nil,
         pingInterval: Int? = nil,
         dateGenerator: @escaping () -> Date = Date.init) {
        session = MediaSessionEntity(id: id,
                               startedAt: startedAt,
                               pingInterval: pingInterval)
        stats = MediaSessionTrackingStats(session: session,
                                          dateGenerator: dateGenerator)
    }
    
    func update(event: Event?, player: MediaPlayerEntity, adBreak: MediaAdBreakEntity?) {
        stats.update(event: event, player: player, adBreak: adBreak)
    }
}
