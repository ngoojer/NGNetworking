
import Foundation

public protocol NGNetwokingAPIClient {
    var session: URLSession { get }
    func APIRequest<T:Decodable>(type:HTTPMethods, URL: String, parameters:[String:String]?, header:[String:String]?, completion: @escaping (Result<T, APIError>) -> Void)
}

public extension NGNetwokingAPIClient {
    
    func APIRequest<T:Decodable>(type:HTTPMethods, URL: String, parameters:[String:
        String]?, header:[String:String]?, completion: @escaping (Result<T, APIError>) -> Void) {
        guard NetworkManager.isNetworkAvailable else{
            completion(.failure(.noNetwork))
            return
        }
        guard var urlComponents = URLComponents(string: URL) else {
            fatalError("Bad URL")
        }
        if let params = parameters, type == .get {
            urlComponents.queryItems = params.map{URLQueryItem(name: $0, value: $1)}
        }
        guard var request = URLRequest(url: urlComponents.url!) as URLRequest? else{
           fatalError("unable to create request")
        }
        
        if type == .post{
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters ?? [:], options: []) else {return}
            request.httpBody = httpBody
        }
        request.httpMethod = type.rawValue
        request.allHTTPHeaderFields = header
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
        if let error = error {
            print("error = \(error)")
            completion(.failure(.jsonDeecodingFailure))
            return
        }
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
            completion(.failure(.responseUnsuccessful))
            return
        }
        
        guard let data = data else {
             completion(.failure(.invalidData))
             return
         }
        
        do {
            let values = try JSONDecoder().decode(T.self, from: data)
            completion(.success(values))
        } catch  {
            print("Error = \(error)")
            completion(.failure(.jsonDeecodingFailure))
        }
        
        }.resume()
    }
}




















