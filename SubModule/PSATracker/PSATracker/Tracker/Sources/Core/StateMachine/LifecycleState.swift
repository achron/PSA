

import Foundation

class LifecycleState: State {
    private(set) var isForeground = false
    private(set) var index: Int

    init(asForegroundWithIndex index: Int) {
        isForeground = true
        self.index = index
    }

    init(asBackgroundWithIndex index: Int) {
        isForeground = false
        self.index = index
    }
}
