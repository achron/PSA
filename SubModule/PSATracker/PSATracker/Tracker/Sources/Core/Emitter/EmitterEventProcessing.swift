

import Foundation

protocol EmitterEventProcessing: AnyObject {
    func addPayload(toBuffer eventPayload: Payload)
    func pauseTimer()
    func resumeTimer()
    func flush()
}
