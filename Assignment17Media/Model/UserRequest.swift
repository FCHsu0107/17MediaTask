//
//  UserRequest.swift
//  Assignment17Media
//
//  Created by Fu-Chiung HSU on 2019/6/4.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import Foundation

enum UserInfoRequest: HTTPRequest {
    case sreachFeature(keyword: String, paging: Int)
    
    var headers: [String : String] {
        switch self {
        case .sreachFeature: return [:]
        }
    }
    
    var body: [String : Any]? {
        switch self {
        case .sreachFeature: return nil
        }
    }
    
    var method: String {
        switch self {
        case .sreachFeature:
            return HTTPMethod.GET.rawValue
        }
    }
    
    var endPoint: String {
        switch self {
        case .sreachFeature(let keyword, let paging):
            return "search/users?q=\(keyword)&page=\(paging)"
       
        }
    }
}
