

import Foundation

class GDPRControllerImpl: Controller, GDPRController {
    var gdpr: GDPRContext?
    
    // MARK: - Methods

    func reset(
        basis basisForProcessing: GDPRProcessingBasis,
        documentId: String?,
        documentVersion: String?,
        documentDescription: String?
    ) {
        gdpr = GDPRContext(
            basis: basisForProcessing,
            documentId: documentId,
            documentVersion: documentVersion,
            documentDescription: documentDescription)
        tracker.gdprContext = gdpr
        dirtyConfig.gdpr = gdpr
    }

    func disable() {
        dirtyConfig.isEnabled = false
        tracker.gdprContext = nil
    }

    var isEnabled: Bool {
        get {
            return tracker.gdprContext != nil
        }
    }

    func enable() -> Bool {
        if let gdpr = gdpr { tracker.gdprContext = gdpr }
        else { return false }
        dirtyConfig.isEnabled = true
        return true
    }

    var basisForProcessing: GDPRProcessingBasis {
        get {
            return ((gdpr)?.basis)!
        }
    }

    var documentId: String? {
        get {
            return (gdpr)?.documentId
        }
    }

    var documentVersion: String? {
        get {
            return (gdpr)?.documentVersion
        }
    }

    var documentDescription: String? {
        get {
            return (gdpr)?.documentDescription
        }
    }

    // MARK: - Private methods

    private var tracker: Tracker {
        get {
            return serviceProvider.tracker
        }
    }

    private var dirtyConfig: GDPRConfiguration {
        get {
            return serviceProvider.gdprConfiguration
        }
    }
}
