

import Foundation

class GlobalContextPluginConfiguration: ConfigurationProtocol, PluginIdentifiable, PluginEntitiesCallable {
    private(set) var identifier: String
    private(set) var globalContext: GlobalContext
    private(set) var entitiesConfiguration: PluginEntitiesConfiguration?

    init(identifier: String, globalContext: GlobalContext) {
        self.identifier = identifier
        self.globalContext = globalContext
        self.entitiesConfiguration = PluginEntitiesConfiguration(closure: globalContext.contexts)
    }
}
