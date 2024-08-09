

import Foundation

class RemoteConfigurationBundle: SerializableConfiguration {
    var schema: String
    var configurationVersion: Int
    var configurationBundle: [ConfigurationBundle] = []
    
    init(schema: String, configurationVersion: Int) {
        self.schema = schema
        self.configurationVersion = configurationVersion
    }
    
    init?(dictionary: [String : Any]) {
        guard let schema = dictionary["$schema"] as? String else {
            logDebug(message: "Error assigning: schema")
            return nil
        }
        self.schema = schema
        guard let configurationVersion = dictionary["configurationVersion"] as? Int else {
            logDebug(message: "Error assigning: configurationVersion")
            return nil
        }
        self.configurationVersion = configurationVersion
        guard let bundles = dictionary["configurationBundle"] as? [[String : Any]] else {
            logDebug(message: "Error assigning: configurationBundle")
            return nil
        }
        self.configurationBundle = bundles.map { ConfigurationBundle(dictionary: $0) }.filter { $0 != nil }.map { $0! }
    }
    
    func updateSourceConfig(_ sourceRemoteBundle: RemoteConfigurationBundle) {
        for bundle in configurationBundle {
            if let sourceBundle = sourceRemoteBundle.configurationBundle.first(where: { $0.namespace == bundle.namespace }) {
                bundle.updateSourceConfig(sourceBundle)
            }
        }
    }

    // MARK: - NSCopying

    override func copy(with zone: NSZone? = nil) -> Any {
        let copy: RemoteConfigurationBundle? = nil
        copy?.schema = schema
        copy?.configurationVersion = configurationVersion
        copy?.configurationBundle = configurationBundle.map { $0.copy(with: zone) as! ConfigurationBundle }
        return copy!
    }

    // MARK: - NSSecureCoding
    
    override class var supportsSecureCoding: Bool { return true }

    override func encode(with coder: NSCoder) {
        coder.encode(schema, forKey: "schema")
        coder.encode(configurationVersion, forKey: "configurationVersion")
        coder.encode(configurationBundle, forKey: "configurationBundle")
    }

    required init?(coder: NSCoder) {
        schema = coder.decodeObject(forKey: "schema") as? String ?? ""
        configurationVersion = coder.decodeInteger(forKey: "configurationVersion")
        if let decodeObject = coder.decodeObject(forKey: "configurationBundle") as? [ConfigurationBundle] {
            configurationBundle = decodeObject
        }
    }
}
