

import Foundation

/// Common parent class for configuration classes.
@objc(SPSerializableConfiguration)
public class SerializableConfiguration: NSObject, NSCopying, NSSecureCoding {
    @objc
    public convenience init?(dictionary: [String : Any]) {
        self.init()
    }

    @objc
    public func copy(with zone: NSZone? = nil) -> Any {
        return SerializableConfiguration()
    }

    @objc
    public func encode(with coder: NSCoder) {
    }

    @objc
    public class var supportsSecureCoding: Bool { return true }
    
    @objc
    required convenience public init?(coder: NSCoder) {
        self.init()
    }
}
