

#if canImport(SwiftUI)

import SwiftUI
import Foundation

@available(iOS 13.0, macOS 10.15, macCatalyst 13.0, tvOS 13.0, *)
@available(watchOS, unavailable)
internal struct ScreenViewModifier: ViewModifier {
    let name: String
    let entities: [(schema: String, data: [String: Any])]
    let trackerNamespace: String?
    
    /// Transform the context entity definitions to self-describing objects
    private var processedEntities: [SelfDescribingJson] {
        return entities.map({ entity in
            return SelfDescribingJson(schema: entity.schema, andDictionary: entity.data)
        })
    }
    
    /// Get tracker by namespace if configured, otherwise return the default tracker
    private var tracker: TrackerController? {
        if let namespace = trackerNamespace {
            return PSATracker.tracker(namespace: namespace)
        } else {
            return PSATracker.defaultTracker()
        }
    }

    /// Modifies the view to track the screen view when it appears
    func body(content: Content) -> some View {
        content.onAppear {
            trackScreenView()
        }
    }

    func trackScreenView() {
        let event = ScreenView(name: name)
        event.entities = processedEntities

        if let tracker = tracker {
            _ = tracker.track(event)
        } else {
            logError(message: "Screen view not tracked – tracker not initialized.")
        }
    }
}

#endif
