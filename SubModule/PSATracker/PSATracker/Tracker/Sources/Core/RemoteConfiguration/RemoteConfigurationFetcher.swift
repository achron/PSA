

import Foundation

class RemoteConfigurationFetcher: NSObject {
    private var remoteConfiguration: RemoteConfiguration
    private var onFetchCallback: OnFetchCallback

    init(remoteSource remoteConfiguration: RemoteConfiguration, onFetchCallback: @escaping OnFetchCallback) {
        self.remoteConfiguration = remoteConfiguration
        self.onFetchCallback = onFetchCallback
        super.init()
        performRequest()
    }

    func performRequest() {
        guard let url = URL(string: remoteConfiguration.endpoint) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"

        var httpResponse: HTTPURLResponse? = nil

        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            httpResponse = urlResponse as? HTTPURLResponse
            let isSuccessful = (httpResponse?.statusCode ?? 0) >= 200 && (httpResponse?.statusCode ?? 0) < 300
            if isSuccessful {
                if let data = data { self.resolveRequest(with: data) }
            }
        }.resume()
    }

    func resolveRequest(with data: Data) {
        if let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String : Any],
           let fetchedConfigurationBundle = RemoteConfigurationBundle(dictionary: jsonObject) {
            onFetchCallback(fetchedConfigurationBundle, ConfigurationState.fetched)
        }
    }
}
