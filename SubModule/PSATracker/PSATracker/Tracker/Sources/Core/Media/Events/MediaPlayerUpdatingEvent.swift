

import Foundation

protocol MediaPlayerUpdatingEvent {
    /// Updates event properties based on the player entity but also updates the player properties based on the event.
    func update(player: MediaPlayerEntity)
}
