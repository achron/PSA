

import Foundation

/// State of retrieved remote configuration that states where the configuration was retrieved from.
@objc(SPConfigurationState)
public enum ConfigurationState: Int {
    /// The default configuration was used.
    case `default`
    /// The configuration was retrieved from local cache.
    case cached
    /// The configuration was retrieved from the remote configuration endpoint.
    case fetched
}
