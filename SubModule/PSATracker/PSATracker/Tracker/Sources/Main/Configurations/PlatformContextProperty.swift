

import Foundation

/// Optional properties tracked in the platform context entity
public enum PlatformContextProperty: Int {
    /// The carrier of the SIM inserted in the device
    case carrier
    /// Type of network the device is connected to
    case networkType
    /// Radio access technology that the device is using
    case networkTechnology
    /// Advertising identifier on iOS
    case appleIdfa
    /// UUID identifier for vendors on iOS
    case appleIdfv
    /// Total physical system memory in bytes
    case physicalMemory
    /// Amount of memory in bytes available to the current app
    /// The property is not tracked in the current version of the tracker due to the tracker not being able to access the API, see the issue here: https://github.com/snowplow/snowplow-ios-tracker/issues/772
    case appAvailableMemory
    /// Remaining battery level as an integer percentage of total battery capacity
    case batteryLevel
    /// Battery state for the device
    case batteryState
    /// A Boolean indicating whether Low Power Mode is enabled
    case lowPowerMode
    /// Bytes of storage remaining
    case availableStorage
    /// Total size of storage in bytes
    case totalStorage
    /// A Boolean indicating whether the device orientation is portrait (either upright or upside down)
    case isPortrait
    /// Screen resolution in pixels. Arrives in the form of WIDTHxHEIGHT (e.g., 1200x900). Doesn't change when device orientation changes
    case resolution
    /// Scale factor used to convert logical coordinates to device coordinates of the screen (uses UIScreen.scale on iOS)
    case scale
    /// System language currently used on the device (ISO 639)
    case language
}
