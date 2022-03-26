//
//  NetworkTasks.swift
//  
//
//  Created by Mateus Rodrigues on 23/03/22.
//

import Foundation
import Network

internal protocol NetworkProtocol {
    associatedtype T: Decodable
    func execute(connection: ConnectionProtocol, completion: @escaping (Result<T?, ErrorsRequests>) -> Void)
    func executeWithParams(connection: ConnectionProtocol, completion: @escaping (Result<T?, ErrorsRequests>) -> Void)
    func decode(_ data: Data, completion: @escaping (T?) -> Void)
}

public struct NetworkTasks<DecodeType: Codable>: NetworkProtocol {
    
    public typealias T = DecodeType
    
    private var client: URLSession
    
    public init(client: URLSession = URLSession.shared) {
        self.client = client
    }
    
    public func execute(connection: ConnectionProtocol, completion: @escaping (Result<T?, ErrorsRequests>) -> Void) {
        
        var components = URLComponents(url: connection.baseUrl.appendingPathComponent(connection.router), resolvingAgainstBaseURL: true)

        var customQueryItems: [URLQueryItem] = []
        connection.components?.forEach({ key, value in
            let item = URLQueryItem(name: key, value: value)
            customQueryItems.append(item)
        })

        components?.queryItems = customQueryItems

        guard let url = components?.url else {
            completion(.failure(.dataNotFound))
            return
        }

        let task = client.dataTask(with: url) { (data, response, error) in

            if let error = error {
                completion(.failure(.error(error: "\(error)")))
                return
            }

            guard let data = data else {
                completion(.failure(.error(error: "Can't get data")))
                return
            }
            
            decode(data) { result in
                if let result = result {
                    completion(.success(result))
                } else {
                    completion(.failure(.errorDecode))
                }
            }
            return
        }

        task.resume()
    }
    
    public func executeWithParams(connection: ConnectionProtocol, completion: @escaping (Result<T?, ErrorsRequests>) -> Void) {
        if let request = getRequest(connection: connection) {
            let task = client.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
                if error != nil {
                    completion(.failure(.error(error: "\(String(describing: error))")))
                }
                guard let checkStatus = response as? HTTPURLResponse else {
                    return
                }
                guard (200...299) ~= checkStatus.statusCode else {
                    completion(.failure(.statusError(error: "Error status - \(checkStatus.statusCode) - \(String(describing: error))")))
                    return
                }
                guard let data = data else {
                    completion(.failure(.dataNotFound))
                    return
                }
                decode(data) { result in
                    if let result = result {
                        completion(.success(result))
                    } else {
                        completion(.failure(.errorDecode))
                    }
                }
            }
            task.resume()
        } else {
            completion(.failure(.error(error: "Not have connection object")))
        }
    }
    
    internal func decode(_ data: Data, completion: @escaping (T?) -> Void) {
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print(json)
                }
            let result = try JSONDecoder().decode(T.self, from: data)
            completion(result)
        } catch {
            completion(nil)
        }
    }
    
    internal func getRequest(connection: ConnectionProtocol) -> URLRequest? {
        let components = URLComponents(url: connection.baseUrl.appendingPathComponent(connection.router), resolvingAgainstBaseURL: true)
        guard let url = components?.url else {
            return nil
        }
        var request = URLRequest(url: url)
        connection.headers?.forEach { key, value in
            request.setValue(key, forHTTPHeaderField: value)
        }
        request.httpMethod = connection.method
        if let parameters = connection.parameters {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            } catch {
                return nil
            }
        }
        
        return request
    }
    
}
