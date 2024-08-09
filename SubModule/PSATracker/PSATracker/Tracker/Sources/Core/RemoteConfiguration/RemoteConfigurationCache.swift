

import Foundation

class RemoteConfigurationCache: NSObject {
    private var cacheFileUrl: URL?
    private var configuration: RemoteConfigurationBundle?

    init(remoteConfiguration: RemoteConfiguration) {
        super.init()
#if !(os(tvOS)) && !(os(watchOS))
        createCachePath(with: remoteConfiguration)
#endif
    }
    
    func read() -> RemoteConfigurationBundle? {
        return lock {
#if !(os(tvOS)) && !(os(watchOS))
            if let configuration = configuration {
                return configuration
            }
            load()
#endif
            return configuration
        }
    }
    
    func write(_ configuration: RemoteConfigurationBundle) {
        lock {
            self.configuration = configuration
#if !(os(tvOS)) && !(os(watchOS))
            store()
#endif
        }
    }
    
    func clear() {
        lock {
            configuration = nil
#if !(os(tvOS)) && !(os(watchOS))
            if let cacheFileUrl = cacheFileUrl {
                do {
                    try FileManager.default.removeItem(at: cacheFileUrl)
                } catch let error {
                    logError(message: String(format: "Error on clearing configuration from cache: %@", error.localizedDescription))
                }
            }
#endif
        }
    }
    
    // Private method
    
    func load() {
        lock {
            guard let cacheFileUrl = cacheFileUrl,
                  let data = try? Data(contentsOf: cacheFileUrl) else { return }
            if #available(iOS 12, tvOS 12, watchOS 5, macOS 10.14, *) {
                do {
                    configuration = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? RemoteConfigurationBundle
                } catch let error {
                    logError(message: String(format: "Exception on getting configuration from cache: %@", error.localizedDescription))
                    configuration = nil
                }
            } else {
                let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
                configuration = unarchiver.decodeObject() as? RemoteConfigurationBundle
                unarchiver.finishDecoding()
            }
        }
    }
    
    func store() {
        _ = DispatchQueue.global(qos: .default)
        lock {
            guard let configuration = configuration,
                  let cacheFileUrl = cacheFileUrl else { return }
            
            do {
                var data = Data()
                var archiver: NSKeyedArchiver?
                
                if #available(iOS 12, tvOS 12, watchOS 5, macOS 10.14, *) {
                    archiver = NSKeyedArchiver(requiringSecureCoding: true)
                    archiver?.encode(configuration, forKey: "root")
                    if let encodedData = archiver?.encodedData {
                        data = encodedData
                    }
                } else {
                    archiver = NSKeyedArchiver(forWritingWith: data as! NSMutableData)
                    archiver?.encode(configuration)
                    archiver?.finishEncoding()
                }
                try data.write(to: cacheFileUrl, options: .atomic)
            } catch let error {
                logError(message: String(format: "Error on caching configuration: %@", error.localizedDescription))
            }
        }
    }

    func createCachePath(with remoteConfiguration: RemoteConfiguration) {
        let fm = FileManager.default
        var url = fm.urls(for: .applicationSupportDirectory, in: .userDomainMask).last
        url = url?.appendingPathComponent("PSATracker-cache")
        do {
            if let url = url {
                try fm.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            }
        } catch {
        }
        let fileName = String(format: "remoteConfig-%lu.data", UInt(abs((remoteConfiguration.endpoint).hash)))
        url = url?.appendingPathComponent(fileName, isDirectory: false)
        if let url = url {
            cacheFileUrl = url
        }
    }
    
    private func lock<T>(closure: () -> T) -> T {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        return closure()
    }
}
