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
    
    var filtersSelected = BehaviorRelay<[String]>(value: [])
    var orderBy = BehaviorRelay<String>(value: "")
}
