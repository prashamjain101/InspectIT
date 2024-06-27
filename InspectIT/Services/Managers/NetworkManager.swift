//
//  NetworkManager.swift
//  InspectIT
//
//  Created by Prasham Jain on 23/06/24.
//

import Foundation

protocol NetworkManaging {
    func request<T: Decodable>(_ endpoint: Endpoint, responseType: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void)
}

class NetworkManager: NetworkManaging {
    
    private let session: URLSession
    private let reachability: Reachability
    
    init(session: URLSession = .shared, reachability: Reachability = Reachability()) {
        if session == .shared {
            let configuration = URLSessionConfiguration.default
            configuration.httpMaximumConnectionsPerHost = 10
            configuration.timeoutIntervalForRequest = 60
            configuration.timeoutIntervalForResource = 60 * 10 // Increase timeout for large resources
            self.session = URLSession(configuration: configuration)
        } else {
            self.session = session
        }
        self.reachability = reachability
    }
    
    func request<T: Decodable>(_ endpoint: Endpoint, responseType: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) {
        
        guard reachability.isConnected else {
            completion(.failure(.noNetwork))
            return
        }
        
        guard let url = URL(string: endpoint.url) else {
            completion(.failure(.badURL))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method
        urlRequest.allHTTPHeaderFields = endpoint.headers
        if let body = endpoint.body {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }
            
            guard let data = data, let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                completion(.failure(.badResponse))
                return
            }
            
            if !data.isEmpty {
                do {
                    let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedResponse))
                } catch {
                    print("Failed to decode request body: \(error)")
                    completion(.failure(.badResponse))
                }
            } else {
                if let body = endpoint.body {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
                        let mappedResponse = try JSONDecoder().decode(T.self, from: jsonData)
                        completion(.success(mappedResponse))
                    } catch {
                        print("Failed to decode request body: \(error)")
                        completion(.failure(.badResponse))
                    }
                } else {
                    completion(.failure(.badResponse))
                }
            }
        }
        task.resume()
    }
}

struct Endpoint {
    let path: String
    let method: String
    var body: [String: Any]?
    var headers: [String: String]?
    
    var url: String {
        return "\(Constants.Webservices.baseURL)\(path)"
    }
}

enum NetworkError: Error {
    case noNetwork
    case badURL
    case requestFailed(Error)
    case badResponse
    case noData
    case encodingError
}
