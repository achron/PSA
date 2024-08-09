

import Foundation

class MediaSchemata {
    private static let schemaPrefix = "iglu:com.snowplowanalytics.snowplow.media/"
    private static let schemaSuffix = "/jsonschema/1-0-0"
    // NOTE: The player schema has a different vendor than the other media schemas because it builds on an older version of the same schema. Versions 5.3 to 5.4.1 of the tracker used a conflicting schema URI which has since been removed from Iglu Central.
    static let playerSchema = "iglu:com.snowplowanalytics.snowplow/media_player/jsonschema/2-0-0"
    static let sessionSchema = "\(schemaPrefix)session\(schemaSuffix)"
    static let adSchema = "\(schemaPrefix)ad\(schemaSuffix)"
    static let adBreakSchema = "\(schemaPrefix)ad_break\(schemaSuffix)"
    
    static func eventSchema(_ eventName: String) -> String {
        return "\(schemaPrefix)\(eventName)_event\(schemaSuffix)"
    }
}
