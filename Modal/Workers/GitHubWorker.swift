//
//  GitHubWorker.swift
//  Modal
//
//  Created by Bruno Alves on 20/08/20.
//  Copyright © 2020 Bruno Alves. All rights reserved.
//

import Foundation

class GitHubWorker {
    
    func fetchListRepositories(success: @escaping ([Repository]) -> Void, fail: @escaping (ApiError) -> Void ) {
        ApiManager.shared.fetch(resource: .repositoryList, query: nil, success: { (data) in
            do {
                let encodedData = try JSONDecoder().decode([Repository].self, from: data)
                success(encodedData)
            } catch {
                fail(.unknowReason)
            }
        }) { (error) in
            fail(error)
        }
    }
    
    func fetchSearch(queryItems: [URLQueryItem], page: Int, success: @escaping (Search) -> Void, fail: @escaping (ApiError) -> Void ) {
        
        ApiManager.shared.fetch(resource: .repositorySearch, query: queryItems, success: { (data) in
            do {
                let encodedData = try JSONDecoder().decode(Search.self, from: data)
                success(encodedData)
            } catch {
                fail(.unknowReason)
            }
        }) { (error) in
            fail(error)
        }
    }
    
}
