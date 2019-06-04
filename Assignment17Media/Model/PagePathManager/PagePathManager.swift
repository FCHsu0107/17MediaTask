//
//  PageManager.swift
//  Assignment17Media
//
//  Created by Fu-Chiung HSU on 2019/6/4.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import Foundation

class PagePathManager {
    
    func getNextPage(linkHeader: String) -> Int? {
        
        let dictionary = getPageInfo(linkHeader: linkHeader)
        
        guard let nextPagePath = dictionary[" rel=\"next\""] else { return nil}
        
        let paging = getPageInt(pagePath: nextPagePath)
        
        return paging
    }
    
    private func getPageInt(pagePath: String) -> Int? {
        
        if let range = pagePath.range(of: "page=") {
            
            let pagingString = pagePath[range.upperBound...]
            
            guard let paging = Int(pagingString) else { return nil }
            
            return paging
        }
        return nil
    }
    
    private func getPageInfo(linkHeader: String) -> [String: String] {
        
        let links = linkHeader.components(separatedBy: ",")
        
        var dictionary: [String: String] = [:]
        
        links.forEach({
            let components = $0.components(separatedBy: ";")
            let cleanPath = components[0].trimmingCharacters(in: CharacterSet(charactersIn: "<>"))
            dictionary[components[1]] = cleanPath
        })
        
        return dictionary
    }
}

