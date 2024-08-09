

import Foundation

protocol ServiceProviderProtocol: AnyObject {
    var namespace: String { get }
    var isTrackerInitialized: Bool { get }
    var tracker: Tracker { get }
    var emitter: Emitter { get }
    var subject: Subject { get }
    var trackerController: TrackerControllerImpl { get }
    var emitterController: EmitterControllerImpl { get }
    var networkController: NetworkControllerImpl { get }
    var gdprController: GDPRControllerImpl { get }
    var globalContextsController: GlobalContextsControllerImpl { get }
    var subjectController: SubjectControllerImpl { get }
    var sessionController: SessionControllerImpl { get }
    var pluginsController: PluginsControllerImpl { get }
    var mediaController: MediaController { get }
    var networkConfiguration: NetworkConfiguration { get }
    var trackerConfiguration: TrackerConfiguration { get }
    var emitterConfiguration: EmitterConfiguration { get }
    var subjectConfiguration: SubjectConfiguration { get }
    var sessionConfiguration: SessionConfiguration { get }
    var gdprConfiguration: GDPRConfiguration { get }
    var ecommerceController: EcommerceController { get }
    var pluginConfigurations: [PluginIdentifiable] { get }
    func addPlugin(plugin: PluginIdentifiable)
    func removePlugin(identifier: String)
}
