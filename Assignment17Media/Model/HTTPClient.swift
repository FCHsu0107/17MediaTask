//
//  HTTPClient.swift
//  Assignment17Media
//
//  Created by Fu-Chiung HSU on 2019/6/3.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import Foundation

enum HTTPError: Error {
    
    case decodeFailed
    
    case requestFailed
    
    case responseError
}

enum HTTPMethod: String {
    
    case GET
    
}

protocol HTTPRequest {
    
    var headers: [String: String] { get }
    
    var body: [String: Any]? { get }
    
    var method: String { get }
    
    var endPoint: String { get }
}

class HTTPClient {
    
    static let shared = HTTPClient()
    
    private let decoder = JSONDecoder()
    
    private let encoder = JSONEncoder()
    
    private init() {}
    
    func request(
        _ request: HTTPRequest,
        completion: @escaping (Result<Data, Error>) -> Void) {
        URLSession.shared.dataTask(
            with: makeRequest(request), completionHandler: {(data, response, error) in
                guard error == nil else {
                    return completion(Result.failure(error!))
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(Result.failure(HTTPError.requestFailed))
                    return
                }
                
                let statusCode = httpResponse.statusCode
                guard let data = data else {
                    completion(Result.failure(HTTPError.responseError))
                    return
                }
                if statusCode == 200 {
                    print("--------------LinkInfo----------")
                    print(httpResponse.allHeaderFields["Link"] as Any)
                    print("-------------response-----------")
                    print(response as Any)
                    
                    completion(Result.success(data))
                    
                } else {
                    
                    completion(Result.failure(HTTPError.responseError))
                    
                }
        }).resume()
    }
    
    private func makeRequest(_ httpRequest: HTTPRequest) -> URLRequest {
        
        let endPoint = httpRequest.endPoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        let urlString = "https://api.github.com" + endPoint
        
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        
        request.allHTTPHeaderFields = httpRequest.headers
        
        if let body = httpRequest.body {
            
            request.httpBody = try! JSONSerialization.data(withJSONObject: body, options: [.prettyPrinted])
        }
        
        request.httpMethod = httpRequest.method
        
        return request
        
    }
}

