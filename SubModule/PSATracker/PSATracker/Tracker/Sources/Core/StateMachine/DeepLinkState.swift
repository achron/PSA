

import Foundation

class DeepLinkState: State {
    private(set) var url: String
    private(set) var referrer: String?
    var readyForOutput = false

    init(url: String, referrer: String?) {
        self.url = url
        self.referrer = referrer
    }
}
