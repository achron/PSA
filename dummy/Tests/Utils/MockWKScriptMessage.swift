

#if os(iOS) || os(macOS)
import WebKit

class MockWKScriptMessage: WKScriptMessage {
    private var messageBody: Any?

    init(body: Any?) {
        super.init()

        messageBody = body
    }

    override var body: Any {
        return messageBody!
    }
}
#endif
