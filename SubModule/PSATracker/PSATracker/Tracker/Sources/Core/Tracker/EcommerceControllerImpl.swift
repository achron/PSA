

import Foundation

class EcommerceControllerImpl: Controller, EcommerceController {
    
    func setEcommerceScreen(_ screen: EcommerceScreenEntity) {
        let plugin = PluginConfiguration(identifier: "ecommercePageTypePluginInternal")
        _ = plugin.entities { _ in [screen.entity] }
        serviceProvider.addPlugin(plugin: plugin)
    }
    
    func setEcommerceUser(_ user: EcommerceUserEntity) {
        let plugin = PluginConfiguration(identifier: "ecommerceUserPluginInternal")
        _ = plugin.entities { _ in [user.entity] }
        serviceProvider.addPlugin(plugin: plugin)
    }
    
    func removeEcommerceScreen() {
        serviceProvider.removePlugin(identifier: "ecommercePageTypePluginInternal")
    }

    func removeEcommerceUser() {
        serviceProvider.removePlugin(identifier: "ecommerceUserPluginInternal")
    }
}
