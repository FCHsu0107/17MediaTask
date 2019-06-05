//
//  HTTPClient.swift
//  Assignment17Media
//
//  Created by Fu-Chiung HSU on 2019/6/3.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import Foundation

struct GitHubReponse {
    
    var data: Data
    
    var link: String?
}

enum HTTPError: Error {
    
    case decodeFailed
    
    case requestFailed
    
    case responseError
    
    case clientError(Data)
    
    case serverError
    
    case unexpectedError
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
        completion: @escaping (Result<GitHubReponse, Error>) -> Void) {
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
                
                switch statusCode {
                    
                case 200..<300:
                    
                    let link = httpResponse.allHeaderFields["Link"] as? String
                    
                    completion(Result.success(GitHubReponse(data: data, link: link)))
                    
                case 400..<500:
                    
                    completion(Result.failure(HTTPError.clientError(data)))
                    
                case 500..<600:
                    
                    completion(Result.failure(HTTPError.serverError))
                    
                default: return

                    completion(Result.failure(HTTPError.unexpectedError))
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

