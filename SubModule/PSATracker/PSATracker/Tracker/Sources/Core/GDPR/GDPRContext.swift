

import Foundation

class GDPRContext: NSObject {
    private(set) var basis: GDPRProcessingBasis
    private(set) var basisString: String
    private(set) var documentId: String?
    private(set) var documentVersion: String?
    private(set) var documentDescription: String?

    /// Set a GDPR context for the tracker
    /// - Parameters:
    ///   - basisForProcessing: Enum one of valid legal bases for processing.
    ///   - documentId: Document ID.
    ///   - documentVersion: Version of the document.
    ///   - documentDescription: Description of the document.
    init(
        basis basisForProcessing: GDPRProcessingBasis,
        documentId: String?,
        documentVersion: String?,
        documentDescription: String?
    ) {
        basisString = GDPRContext.string(from: basisForProcessing)
        basis = basisForProcessing
        self.documentId = documentId
        self.documentVersion = documentVersion
        self.documentDescription = documentDescription
        super.init()
    }

    /// Return context with value stored about GDPR processing.
    var context: SelfDescribingJson {
        get {
            var data: [String : String] = [:]
            data[kSPBasisForProcessing] = basisString
            data[kSPDocumentId] = documentId
            data[kSPDocumentVersion] = documentVersion
            data[kSPDocumentDescription] = documentDescription
            return SelfDescribingJson(schema: kSPGdprContextSchema, andDictionary: data)
        }
    }

    // MARK: Private methods

    static func string(from basis: GDPRProcessingBasis) -> String {
        switch basis {
        case .consent:
            return "consent"
        case .contract:
            return "contract"
        case .legalObligation:
            return "legal_obligation"
        case .vitalInterest:
            return "vital_interests"
        case .publicTask:
            return "public_task"
        case .legitimateInterests:
            return "legitimate_interests"
        }
    }
}
