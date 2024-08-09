

import Foundation

#if swift(>=5.4)
/// Result builder used to build a list of configuration objects when creating a new tracker
@resultBuilder
public struct ConfigurationBuilder {
    public static func buildExpression(_ expression: [ConfigurationProtocol]) -> [ConfigurationProtocol] {
        return expression
    }
    
    public static func buildExpression(_ expression: ConfigurationProtocol) -> [ConfigurationProtocol] {
        return [expression]
    }
    
    public static func buildBlock() -> [ConfigurationProtocol] {
        return []
    }
    
    public static func buildBlock(_ configurations: ConfigurationProtocol...) -> [ConfigurationProtocol] {
        return configurations.map { $0 }
    }
    
    public static func buildBlock(_ configurations: [ConfigurationProtocol]...) -> [ConfigurationProtocol] {
        return configurations.flatMap { $0 }
    }
    
    public static func buildArray(_ configurations: [[ConfigurationProtocol]]) -> [ConfigurationProtocol] {
        return configurations.flatMap { $0 }
    }
    
    public static func buildArray(_ configurations: [ConfigurationProtocol]) -> [ConfigurationProtocol] {
        return configurations
    }
    
    public static func buildEither(first configurations: [ConfigurationProtocol]) -> [ConfigurationProtocol] {
        return configurations
    }
    
    public static func buildEither(first configuration: ConfigurationProtocol) -> [ConfigurationProtocol] {
        return [configuration]
    }
    
    public static func buildEither(second configuration: [ConfigurationProtocol]) -> [ConfigurationProtocol] {
        return configuration
    }
    
    public static func buildEither(second configuration: ConfigurationProtocol) -> [ConfigurationProtocol] {
        return [configuration]
    }
    
    public static func buildOptional(_ configurations: [ConfigurationProtocol]?) -> [ConfigurationProtocol] {
        return configurations ?? []
    }
}
#endif
