import Network

struct NetworkManager {

    static let environment : APIEnvironment = .production
    static var isNetworkAvailable:Bool {
        let reachability = try! Reachability()
        let reachabilityStatus = reachability.connection
        return reachabilityStatus != .unavailable
    }

}

public enum APIEnvironment {
    case development
    case production
    case staging
}

public enum HTTPMethods: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public enum APIError: Error {
    case noNetwork
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful
    case jsonDeecodingFailure
    
    var localizedDescription: String {
        switch self {
        case .noNetwork: return "No internet connection"
        case .requestFailed: return "Request Failed"
        case .invalidData: return "Invalid Data"
        case .responseUnsuccessful: return "Response Unsuccessful"
        case .jsonConversionFailure: return "JSON Parsing Failure"
        case .jsonDeecodingFailure: return "Unbale to decode response."
        }
    }
}
