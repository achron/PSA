

import Foundation

@objc(SPController)
public class Controller: NSObject {
    private(set) var serviceProvider: ServiceProviderProtocol

    init(serviceProvider: ServiceProviderProtocol) {
        self.serviceProvider = serviceProvider
        super.init()
    }
}
