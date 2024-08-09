

import Foundation

class GlobalContextsControllerImpl: Controller, GlobalContextsController {

    var contextGenerators: [String : GlobalContext] {
        get {
            var contexts: [String : GlobalContext] = [:]
            for configuration in pluginConfigurations {
                contexts[configuration.identifier] = configuration.globalContext
            }
            return contexts
        }
        set {
            for configuration in pluginConfigurations {
                serviceProvider.pluginsController.remove(identifier: configuration.identifier)
            }
            for (identifier, globalContext) in newValue {
                let plugin = GlobalContextPluginConfiguration(identifier: identifier,
                                                              globalContext: globalContext)
                serviceProvider.pluginsController.add(plugin: plugin)
            }
        }
    }

    func add(tag: String, contextGenerator generator: GlobalContext) -> Bool {
        if tags.contains(tag) {
            return false
        }
        let plugin = GlobalContextPluginConfiguration(identifier: tag,
                                                      globalContext: generator)
        serviceProvider.pluginsController.add(plugin: plugin)
        return true
    }

    func remove(tag: String) -> GlobalContext? {
        let configuration = pluginConfigurations.first { configuration in
            configuration.identifier == tag
        }
        serviceProvider.pluginsController.remove(identifier: tag)
        return configuration?.globalContext
    }

    var tags: [String] {
        return pluginConfigurations.map { $0.identifier }
    }

    // MARK: - Private methods

    private var pluginConfigurations: [GlobalContextPluginConfiguration] {
        return serviceProvider.pluginConfigurations.filter { configuration in
            configuration is GlobalContextPluginConfiguration
        }.map { configuration in
            configuration as! GlobalContextPluginConfiguration
        }
    }
}
