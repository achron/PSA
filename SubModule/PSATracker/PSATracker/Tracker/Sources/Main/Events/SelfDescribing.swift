

import Foundation

/// A self-describing event.
@objc(SPSelfDescribing)
public class SelfDescribing: SelfDescribingAbstract {
    @objc
    public convenience init(eventData: SelfDescribingJson) {
        self.init(schema: eventData.schema, payload: eventData.data)
    }

    @objc
    public init(schema: String, payload: [String : Any]) {
        self._schema = schema
        self._payload = payload
    }
    
    private var _schema: String
    override var schema: String {
        get { return _schema }
        set { _schema = newValue }
    }
    
    private var _payload: [String : Any]
    override var payload: [String : Any] {
        get { return _payload }
        set {
            _payload = newValue
        }
    }
    
    var eventData: SelfDescribingJson {
        set {
            schema = newValue.schema
            payload = newValue.data
        }
        get {
            return SelfDescribingJson(schema: schema, andDictionary: payload)
        }
    }
}
