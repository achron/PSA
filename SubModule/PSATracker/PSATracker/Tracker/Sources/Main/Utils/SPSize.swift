

import Foundation

@objc
public class SPSize: NSObject, NSCoding {
    @objc
    public private(set) var width = 0
    @objc
    public private(set) var height = 0

    @objc
    public init(width: Int, height: Int) {
        super.init()
        self.width = width
        self.height = height
    }

    public func encode(with coder: NSCoder) {
        coder.encode(width, forKey: "width")
        coder.encode(height, forKey: "height")
    }

    required public init?(coder: NSCoder) {
        super.init()
        width = coder.decodeInteger(forKey: "width")
        height = coder.decodeInteger(forKey: "height")
    }
}
