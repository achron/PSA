

import Foundation

@objc(SPSchemaRuleset)
public class SchemaRuleset: NSObject, NSCopying {
    private var rulesDenied: [SchemaRule] = []
    @objc
    public var denied: [String] {
        return rulesDenied.map { $0.rule }
    }

    private var rulesAllowed: [SchemaRule] = []
    @objc
    public var allowed: [String] {
        return rulesAllowed.map { $0.rule }
    }

    @objc
    public var filterBlock: FilterBlock {
        return { [self] event in
            if let schema = event.schema {
                return match(withUri: schema)
            }
            return false
        }
    }

    public func copy(with zone: NSZone? = nil) -> Any {
        return SchemaRuleset(allowedList: allowed, andDeniedList: denied)
    }

    /// Generate a set of rules based on allowed and denied event schemas.
    /// - Parameters:
    ///   - allowed: Rules of allowed schemas.
    ///   - denied: Rules of denied schemas.
    @objc
    public init(allowedList allowed: [String], andDeniedList denied: [String]) {
        for rule in allowed {
            if let schemaRule = SchemaRule(rule: rule) {
                rulesAllowed.append(schemaRule)
            }
        }
        
        for rule in denied {
            if let schemaRule = SchemaRule(rule: rule) {
                rulesDenied.append(schemaRule)
            }
        }
    }

    /// Generate a set of rules based on allowed and denied event schemas.
    /// - Parameter allowed: Rules of allowed schemas.
    @objc
    public convenience init(allowedList allowed: [String]) {
        self.init(allowedList: allowed, andDeniedList: [])
    }

    /// Generate a set of rules based on allowed and denied event schemas.
    /// - Parameter denied: Rules of denied schemas.
    @objc
    public convenience init(deniedList denied: [String]) {
        self.init(allowedList: [], andDeniedList: denied)
    }

    /// Weather the `uri` match the stored rules.
    /// - Parameter uri: URI to check.
    /// - Returns: Weather the uri is allowed.
    @objc
    public func match(withUri uri: String) -> Bool {
        for rule in rulesDenied {
            if rule.match(withUri: uri) {
                return false
            }
        }
        if rulesAllowed.count == 0 {
            return true
        }
        for rule in rulesAllowed {
            if rule.match(withUri: uri) {
                return true
            }
        }
        return false
    }

    @objc
    public override var description: String {
        return "SchemaRuleset:\r\n  allowed:\(allowed)\r\n  denied:\(denied)\r\n"
    }
}
