

#if canImport(SwiftUI)
import SwiftUI
import Foundation

@available(iOS 13.0, macOS 10.15, macCatalyst 13.0, tvOS 13.0, *)
@available(watchOS, unavailable)
public extension View {
    /// Sets up screen view tracking to track events when this screen appears.
    /// - Parameter name: Name of the screen
    /// - Parameter contexts: Context entities to attach to the event
    /// - Returns: View with the attached modifier to track screen views
    func snowplowScreen(name: String,
                        entities: [(schema: String, data: [String : Any])] = [],
                        trackerNamespace: String? = nil) -> some View {
        return modifier(ScreenViewModifier(name: name,
                                           entities: entities,
                                           trackerNamespace: trackerNamespace))
    }
}

#endif
