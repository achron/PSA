

import Foundation

/**
 Media tracking instance with methods to track media events.
 */
@objc(SPMediaTracking)
public protocol MediaTracking {
    
    /// Unique identifier for the media tracking instance. The same ID is used for media player session if enabled.
    @objc
    var id: String { get }
    
    /// Updates stored attributes of the media player such as the current playback.
    /// Use this function to continually update the player attributes so that they can be sent in the background ping events.
    ///
    /// - Parameter player: Updates to the properties for the media player context entity attached to media events.
    @objc
    func update(player: MediaPlayerEntity?)
    
    /// Updates stored attributes of the media player such as the current playback.
    /// Use this function to continually update the player attributes so that they can be sent in the background ping events.
    ///
    /// - Parameter player: Updates to the properties for the media player context entity attached to media events.
    /// - Parameter ad: Updates to the properties for the ad context entity attached to media events during ad playback.
    /// - Parameter adBreak: Updates to the properties for the ad break context entity attached to media events during ad break playback.
    @objc
    func update(player: MediaPlayerEntity?, ad: MediaAdEntity?, adBreak: MediaAdBreakEntity?)
    
    ///  Tracks a media player event along with the media entities (e.g., player, session, ad).
    ///
    /// - Parameter event: Event to track.
    @objc
    func track(_ event: Event)
    
    ///  Tracks a media player event along with the media entities (e.g., player, session, ad).
    ///
    /// - Parameter event: Event to track.
    /// - Parameter player: Updates to the properties for the media player context entity attached to media events.
    @objc
    func track(_ event: Event, player: MediaPlayerEntity?)
    
    ///  Tracks a media player event along with the media entities (e.g., player, session, ad).
    ///
    /// - Parameter event: Event to track.
    /// - Parameter ad: Updates to the properties for the ad context entity attached to media events during ad playback.
    @objc
    func track(_ event: Event, ad: MediaAdEntity?)
    
    ///  Tracks a media player event along with the media entities (e.g., player, session, ad).
    ///
    /// - Parameter event: Event to track.
    /// - Parameter player: Updates to the properties for the media player context entity attached to media events.
    /// - Parameter ad: Updates to the properties for the ad context entity attached to media events during ad playback.
    @objc
    func track(_ event: Event, player: MediaPlayerEntity?, ad: MediaAdEntity?)
    
    ///  Tracks a media player event along with the media entities (e.g., player, session, ad).
    ///
    /// - Parameter event: Event to track.
    /// - Parameter adBreak: Updates to the properties for the ad break context entity attached to media events during ad break playback.
    @objc
    func track(_ event: Event, adBreak: MediaAdBreakEntity?)
    
    ///  Tracks a media player event along with the media entities (e.g., player, session, ad).
    ///
    /// - Parameter event: Event to track.
    /// - Parameter player: Updates to the properties for the media player context entity attached to media events.
    /// - Parameter adBreak: Updates to the properties for the ad break context entity attached to media events during ad break playback.
    @objc
    func track(_ event: Event, player: MediaPlayerEntity?, adBreak: MediaAdBreakEntity?)
    
    ///  Tracks a media player event along with the media entities (e.g., player, session, ad).
    ///
    /// - Parameter event: Event to track.
    /// - Parameter player: Updates to the properties for the media player context entity attached to media events.
    /// - Parameter ad: Updates to the properties for the ad context entity attached to media events during ad playback.
    /// - Parameter adBreak: Updates to the properties for the ad break context entity attached to media events during ad break playback.
    @objc
    func track(_ event: Event, player: MediaPlayerEntity?, ad: MediaAdEntity?, adBreak: MediaAdBreakEntity?)
}
