//
//  FilterViewModel.swift
//  Modal
//
//  Created by Bruno Alves on 20/08/20.
//  Copyright © 2020 Bruno Alves. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class FilterViewModel {
    
    var filtersSelected = BehaviorRelay<[Filter]>(value: [])
    var orderBy = BehaviorRelay<Sorting>(value: .descending)
    
    init(filter: [Filter]) {
        self.filtersSelected.accept(filter)
    }
    
    // MARK: - Computed properties
    
    var filters: BehaviorRelay<[Filter]> {
        return BehaviorRelay(value: [.star, .forks, .updated])
    }
    
    var order: BehaviorRelay<[Sorting]> {
        return BehaviorRelay(value: [.descending, .ascending])
    }
}
