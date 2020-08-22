//
//  FilterModel.swift
//  Modal
//
//  Created by Bruno Alves on 21/08/20.
//  Copyright © 2020 Bruno Alves. All rights reserved.
//

import Foundation

enum Filter {
    case star
    case followers
    case date
    
    var describing: String {
        switch self {
        case .star:
            return "Estrelas"
        case .followers:
            return "Seguidores"
        case .date:
            return "Data"
        }
    }
}

enum Sorting {
    case ascending
    case descending
    
    var describing: String {
        switch self {
        case .ascending:
            return "Crescente"
        case .descending:
            return "Decresccente"
        }
    }
}

struct FilterModel {
    
    private var filter: Filter
    private var sort: Sorting
    
    init(filter: Filter, orderBy: Sorting) {
        self.filter = filter
        self.sort = orderBy
    }
    
    var filterName: String {
        return filter.describing
    }
    
    var sorName: String {
        return sort.describing
    }
}
