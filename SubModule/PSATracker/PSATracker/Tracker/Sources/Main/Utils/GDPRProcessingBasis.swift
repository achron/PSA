

import Foundation

@objc(SPGDPRProcessingBasis)
public enum GDPRProcessingBasis : Int {
    case consent = 0
    case contract = 1
    case legalObligation = 2
    case vitalInterest = 3
    case publicTask = 4
    case legitimateInterests = 5
}
