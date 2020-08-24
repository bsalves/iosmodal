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
    case forks
    case updated

    var describing: String {
        switch self {
        case .star:
            return String.localize("filter_star")
        case .forks:
            return String.localize("filter_forks")
        case .updated:
            return String.localize("filter_updated")
        }
    }

    var key: String {
        switch self {
        case .star:
            return "stars"
        case .forks:
            return "forks"
        case .updated:
            return "updated"
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

    var key: String {
        switch self {
        case .ascending:
            return "asc"
        case .descending:
            return "desc"
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
