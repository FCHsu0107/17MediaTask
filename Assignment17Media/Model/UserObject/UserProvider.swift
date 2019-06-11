//
//  UserProvider.swift
//  Assignment17Media
//
//  Created by Fu-Chiung HSU on 2019/6/4.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import Foundation

typealias UserSearchResultsHanlder = (Result<ResultsWithPageInfo, Error>) -> Void

class UserProvider {
    
    let decoder = JSONDecoder()
    
    func fetchSearchResults(keyworkd: String, paging: Int, completion: @escaping UserSearchResultsHanlder) {
        HTTPClient.shared.request(
            UserInfoRequest.searchFeature(keyword: keyworkd, paging: paging),
            completion: {[weak self] result in
                guard let strongSelf = self else { return }
                
                switch result {
                case .success(let reponse):
                    do {
                        let users = try strongSelf.decoder.decode(SearchResults.self, from: reponse.data)
                        
                        let pagingManager = PagePathManager()
                        
                        if let headerLink = reponse.link {
                            
                            let paging: Int? = pagingManager.getNextPage(linkHeader: headerLink)
                            
                            DispatchQueue.main.async {
                                completion(Result.success(ResultsWithPageInfo(paging: paging, results: users)))
                            }
                            
                        } else {
                            DispatchQueue.main.async {
                                completion(Result.success(ResultsWithPageInfo(paging: nil, results: users)))
                            }
                        }
                     
                    } catch {
                        completion(Result.failure(error))
                    }
                    
                    
                case .failure(let error):
                    completion(Result.failure(error))
                }
        })
    }
}
