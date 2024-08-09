

#if os(iOS)
import Foundation
import SystemConfiguration

enum SNOWNetworkStatus : Int {
    case offline
    case wifi
    case wwan
}

class NetworkReachability: NSObject {
    private var reachability: SCNetworkReachability

    var networkStatus: SNOWNetworkStatus! {
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(reachability, &flags) {
            return .offline
        }
        return reachabilityStatus(for: flags)
    }

    init(reachability: SCNetworkReachability) {
        self.reachability = reachability
    }

    class func forInternetConnection() -> NetworkReachability? {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let reachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return nil
        }

        return NetworkReachability(reachability: reachability)
    }

    // MARK: - Private methods

    private func reachabilityStatus(for flags: SCNetworkReachabilityFlags) -> SNOWNetworkStatus {
        let isReachable = (flags.rawValue & SCNetworkReachabilityFlags.reachable.rawValue) != 0
        let isConnectionRequired = (flags.rawValue & SCNetworkReachabilityFlags.connectionRequired.rawValue) != 0
        let isOnDemand = (flags.rawValue & SCNetworkReachabilityFlags.connectionOnDemand.rawValue) != 0
        let isOnTraffic = (flags.rawValue & SCNetworkReachabilityFlags.connectionOnTraffic.rawValue) != 0
        let isInterventionRequired = (flags.rawValue & SCNetworkReachabilityFlags.interventionRequired.rawValue) != 0

        if !isReachable {
            return .offline
        }

        #if os(iOS)
        let isWWAN = (flags.rawValue & SCNetworkReachabilityFlags.isWWAN.rawValue) == SCNetworkReachabilityFlags.isWWAN.rawValue
        if isWWAN {
            return .wwan
        }
        #endif

        var returnValue: SNOWNetworkStatus = .offline
        if !isConnectionRequired {
            // If the target host is reachable and no connection is required then we'll assume (for now) that you're on Wi-Fi
            returnValue = .wifi
        }
        if isOnDemand || isOnTraffic {
            //... and the connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs...
            if !isInterventionRequired {
                //... and no [user] intervention is needed...
                returnValue = .wifi
            }
        }
        return returnValue
    }

    deinit {
    }
}
#endif
