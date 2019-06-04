//
//  PageManager.swift
//  Assignment17Media
//
//  Created by Fu-Chiung HSU on 2019/6/4.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import Foundation
class PagePathManager {
    
    func getNextPage(linkHeader: String) -> String? {
        let links = linkHeader.components(separatedBy: ",")
        var dictionary: [String: String] = [:]
        links.forEach({
            let components = $0.components(separatedBy: ";")
            let cleanPath = components[0].trimmingCharacters(in: CharacterSet(charactersIn: "<>"))
            dictionary[components[1]] = cleanPath
        })
        let nextPagePath = dictionary[" rel=\"next\""]
        
        return nextPagePath
    }
}

