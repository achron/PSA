

import Foundation

@objc(SPGlobalContextsConfigurationProtocol)
public protocol GlobalContextsConfigurationProtocol: AnyObject {
    @objc
    var contextGenerators: [String : GlobalContext] { get set }
    /// Add a GlobalContext generator to the configuration of the tracker.
    /// - Parameters:
    ///   - tag: The label identifying the generator in the tracker.
    ///   - generator: The GlobalContext generator.
    /// - Returns: Whether the adding operation has succeeded.
    @objc
    func add(tag: String, contextGenerator generator: GlobalContext) -> Bool
    /// Remove a GlobalContext generator from the configuration of the tracker.
    /// - Parameter tag: The label identifying the generator in the tracker.
    /// - Returns: Whether the removing operation has succeded.
    @objc
    func remove(tag: String) -> GlobalContext?
}

/// This class allows the setup of Global Contexts which are attached to selected events.
@objc(SPGlobalContextsConfiguration)
public class GlobalContextsConfiguration: NSObject, GlobalContextsConfigurationProtocol, ConfigurationProtocol {
    @objc
    public var contextGenerators: [String : GlobalContext] = [:]

    @objc
    public func add(tag: String, contextGenerator generator: GlobalContext) -> Bool {
        if (contextGenerators)[tag] != nil {
            return false
        }
        (contextGenerators)[tag] = generator
        return true
    }

    @objc
    public func remove(tag: String) -> GlobalContext? {
        let toDelete = (contextGenerators)[tag]
        if toDelete != nil {
            contextGenerators.removeValue(forKey: tag)
        }
        return toDelete
    }
    
    // MARK: - Builders
    
    public func contextGenerators(_ generators: [String : GlobalContext]) -> Self {
        self.contextGenerators = generators
        return self
    }
    
    // MARK: - Internal functions
    
    func toPluginConfigurations() -> [GlobalContextPluginConfiguration] {
        return contextGenerators.map { (identifier, globalContext) in
            return GlobalContextPluginConfiguration(identifier: identifier,
                                                    globalContext: globalContext)
        }
    }
}
