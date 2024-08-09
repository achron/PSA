

import Foundation

class MediaPingInterval {
    var pingInterval: Int
    
    private var timer: Timer?
    private var timerProvider: Timer.Type
    private var paused: Bool?
    private var numPausedPings: Int = 0
    private var maxPausedPings: Int = 1
    private var isPaused: Bool { paused == true }
    
    init(pingInterval: Int? = nil,
         maxPausedPings: Int? = nil,
         timerProvider: Timer.Type = Timer.self) {
        if let maxPausedPings = maxPausedPings {
            self.maxPausedPings = maxPausedPings
        }
        self.pingInterval = pingInterval ?? 30
        self.timerProvider = timerProvider
    }
    
    func update(player: MediaPlayerEntity) {
        paused = player.paused ?? true
        if paused == false { numPausedPings = 0 }
    }
    
    func subscribe(callback: @escaping () -> ()) {
        end()
        
        timer = timerProvider.scheduledTimer(withTimeInterval: TimeInterval(pingInterval),
                                             repeats: true) { _ in
            if !self.isPaused || self.numPausedPings < self.maxPausedPings {
                if self.isPaused {
                    self.numPausedPings += 1
                }
                callback()
            }
        }
    }
    
    func end() {
        timer?.invalidate()
        timer = nil
    }
}
