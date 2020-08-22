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
            return String.localize("filter_star")
        case .followers:
            return String.localize("filter_followers")
        case .date:
            return String.localize("filter_date")
        }
    }
}

enum Sorting {
    case ascending
    case descending
    
    var describing: String {
        switch self {
        case .ascending:
            return String.localize("sort_asc")
        case .descending:
            return String.localize("sort_desc")
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
