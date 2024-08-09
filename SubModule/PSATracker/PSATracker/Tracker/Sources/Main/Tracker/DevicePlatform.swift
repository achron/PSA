

import Foundation

@objc(SPDevicePlatform)
public enum DevicePlatform : Int {
    case web = 0
    case mobile
    case desktop
    case serverSideApp
    case general
    case connectedTV
    case gameConsole
    case internetOfThings
}

func devicePlatformToString(_ devicePlatform: DevicePlatform) -> String? {
    switch devicePlatform {
    case .web:
        return "web"
    case .mobile:
        return "mob"
    case .desktop:
        return "pc"
    case .serverSideApp:
        return "srv"
    case .general:
        return "app"
    case .connectedTV:
        return "tv"
    case .gameConsole:
        return "cnsl"
    case .internetOfThings:
        return "iot"
    }
}

func stringToDevicePlatform(_ devicePlatformString: String) -> DevicePlatform? {
    if let index = ["web", "mob", "pc", "srv", "app", "tv", "cnsl", "iot"].firstIndex(of: devicePlatformString) {
        return DevicePlatform(rawValue: index)
    }
    return nil
}
