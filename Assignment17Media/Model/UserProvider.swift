//
//  UserProvider.swift
//  Assignment17Media
//
//  Created by Fu-Chiung HSU on 2019/6/4.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import Foundation

typealias UserSearchResultsHanlder = (Result<UserObject, Error>) -> Void

class UserProvider {
    
    let decoder = JSONDecoder()
    
    func fetchSreachResults(keyworkd: String, paging: Int, completion: @escaping UserSearchResultsHanlder) {
        HTTPClient.shared.request(
            UserInfoRequest.sreachFeature(keyword: keyworkd, paging: paging),
            completion: {[weak self] result in
                guard let strongSelf = self else { return }
                
                switch result {
                case .success(let data):
                    do {
                        let users = try strongSelf.decoder.decode(UserObject.self, from: data)
                        
                        DispatchQueue.main.async {
                            completion(Result.success(users))
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
