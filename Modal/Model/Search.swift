//
//  Search.swift
//  Modal
//
//  Created by Bruno Alves on 23/08/20.
//  Copyright © 2020 Bruno Alves. All rights reserved.
//

import Foundation

// MARK: - Search
struct Search: Codable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [Repository]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}
