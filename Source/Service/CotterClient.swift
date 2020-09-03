//
//  CotterAPI.swift
//  Cotter
//
//  Created by Albert Purnama on 3/1/20.
//

import Foundation
import os.log

public protocol APIClient: MockedClient {
    func send<T: APIRequest>(
        _ request: T,
        completion: @escaping ResultCallback<T.Response>
    )
}

// MARK: - NetworkSession Protocol for loadData Function
public protocol NetworkSession {
    func loadData(urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
}

// MARK: - URLSession implements the loadData method, which will call session.dataTask to make the HTTP Request
extension URLSession: NetworkSession {
    public func loadData(urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let task = dataTask(with: urlRequest) { data, response, error in
            completionHandler(data, response, error)
        }
        task.resume()
    }
}

public class CotterClient: APIClient {
    private let baseURL: URL
    private let apiPrefixPath: String = "/api/v0"
    private let session: NetworkSession
    
    private let apiKeyID: String
    private let apiSecretKey: String
    
    public init(apiKeyID: String, apiSecretKey: String, url: String, session: NetworkSession = URLSession.shared) {
        self.session = session
        self.baseURL = URL(string: url)!
        self.apiKeyID = apiKeyID
        self.apiSecretKey = apiSecretKey
    }
    
    // send will run completion function inside a Dispatch.main.async function
    public func send<T: APIRequest>(_ request: T, completion: @escaping ResultCallback<T.Response>) {
        let urlrequest = self.urlrequest(for: request)
        
        // loadData will call URLSession.dataTask to make the HTTP Request
        session.loadData(urlRequest: urlrequest) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else { // check for fundamental networking error
                    DispatchQueue.main.async {
                        completion(.failure(CotterError.network))
                    }
                return
            }
            
            os_log("%{public}@ http {status: %d msg: %{public}@ response: %{public}@}",
                   log: Config.instance.log, type: .debug,
                   #function, response.statusCode, String(decoding: data, as:UTF8.self), response)

            guard (200 ... 299) ~= response.statusCode else {   // check for http errors
                DispatchQueue.main.async {
                    completion(.failure(CotterError.status(code: response.statusCode)))
                }
                return
            }
            
            do {
                // Decode the response using given response object
                let resp = try JSONDecoder().decode(T.Response.self, from: data)
                
                // since we have decoded the response, we can just take return the response
                DispatchQueue.main.async {
                    completion(.success(resp))
                }
            } catch {
                // failing to decode will result in failure
                DispatchQueue.main.async {
                    completion(.failure(CotterError.general(message: error.localizedDescription)))
                }
            }
        }
        
    }
    
    private func urlrequest<T: APIRequest>(for request: T) -> URLRequest {
        guard let baseUrl = URL(string: self.apiPrefixPath + request.path, relativeTo: baseURL) else {
            fatalError("Bad resourceName: \(request.path)")
        }

        let components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)!
        
        // create request
        var req = URLRequest(url: components.url!)
        
        // fill the required request headers
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue(self.apiSecretKey, forHTTPHeaderField: "API_SECRET_KEY")
        req.setValue(self.apiKeyID, forHTTPHeaderField: "API_KEY_ID")
        req.httpMethod = request.method
        
        // fill in the body with json if exist
        if request.body != nil {
            req.httpBody = request.body
        }
        
        // Construct the final URL with all the previous data
        return req
    }
}
