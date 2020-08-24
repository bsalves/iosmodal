//
//  Repository.swift
//  Modal
//
//  Created by Bruno Alves on 23/08/20.
//  Copyright © 2020 Bruno Alves. All rights reserved.
//

import Foundation

// MARK: - Repository
struct Repository: Codable {
    let id: Int
    let fullName: String
    let owner: Owner
    let forksCount: Int?
    let stargazersCount: Int?
    let watchersCount: Int?
    let updatedAt: String?
    
    var createdDateTime: String {
        
        guard let createdString = self.updatedAt else { return String() }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: createdString) ?? Date()
        let customDateFormatter = DateFormatter()
        customDateFormatter.dateFormat = "MMM yyyy"
        return customDateFormatter.string(from: date)
    }

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case owner
        case forksCount = "forks_count"
        case stargazersCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case updatedAt = "updated_at"
    }
    
    
    // MARK: - Owner
    struct Owner: Codable {
        let avatarURL: String

        enum CodingKeys: String, CodingKey {
            case avatarURL = "avatar_url"
        }
    }
}




