//
//  UserObject.swift
//  Assignment17Media
//
//  Created by Fu-Chiung HSU on 2019/6/3.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import Foundation

struct SearchResults: Codable {
    
    var totalCount: Int
    
    var incompleteResults: Bool
    
    var items: [UserInfoObject]
    
    enum CodingKeys: String, CodingKey {
        
        case totalCount = "total_count"
        
        case incompleteResults = "incomplete_results"
        
        case items
    }
}

struct UserInfoObject: Codable {
    
    var login: String
    
    var url: String
    
    var avatarUrl: String
    
    enum CodingKeys: String, CodingKey {
        
        case login
        
        case url
        
        case avatarUrl = "avatar_url"
    }
}

struct ResultsWithPageInfo {
    
    var paging: Int?
    
    var results: SearchResults
}

struct SearchParameter {
    
    var keyword: String
    
    var paging: Int?
    
}
