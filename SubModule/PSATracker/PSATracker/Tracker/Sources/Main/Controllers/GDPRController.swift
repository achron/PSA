

import Foundation

@objc(SPGDPRController)
public protocol GDPRController: GDPRConfigurationProtocol {
    /// Whether the recorded GDPR context is enabled and will be attached as context.
    @objc
    var isEnabled: Bool { get }
    /// Reset GDPR context to be sent with each event.
    /// - Parameters:
    ///   - basisForProcessing: GDPR Basis for processing.
    ///   - documentId: ID of a GDPR basis document.
    ///   - documentVersion: Version of the document.
    ///   - documentDescription: Description of the document.
    @objc
    func reset(
            basis basisForProcessing: GDPRProcessingBasis,
            documentId: String?,
            documentVersion: String?,
            documentDescription: String?
        )
    /// Enable the GDPR context recorded.
    @objc
    func enable() -> Bool
    /// Disable the GDPR context recorded.
    @objc
    func disable()
}
