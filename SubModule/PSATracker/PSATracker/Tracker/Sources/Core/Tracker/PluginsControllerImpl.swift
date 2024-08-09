

import Foundation

class PluginsControllerImpl: Controller, PluginsController {
    var identifiers: [String] {
        return serviceProvider.pluginConfigurations.map { $0.identifier }
    }
    
    func add(plugin: PluginIdentifiable) {
        serviceProvider.addPlugin(plugin: plugin)
    }

    func remove(identifier: String) {
        serviceProvider.removePlugin(identifier: identifier)
    }
}
