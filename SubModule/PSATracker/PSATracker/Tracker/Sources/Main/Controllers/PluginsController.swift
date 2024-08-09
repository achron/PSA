

import Foundation

@objc(SPPluginsController)
public protocol PluginsController {
    @objc
    var identifiers: [String] { get }
    @objc
    func add(plugin: PluginIdentifiable)
    @objc
    func remove(identifier: String)
}
