//
//  MainViewModel.swift
//  Modal
//
//  Created by Bruno Alves on 20/08/20.
//  Copyright © 2020 Bruno Alves. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class MainViewModel {
    
    private(set) var data = BehaviorRelay<[String]>(value: [])
    
    var filters = BehaviorRelay<[Filter]>(value: [])
    
    private var bag = DisposeBag()
    var filterViewModel: FilterViewModel!
    
    init() {
        self.filterViewModel = FilterViewModel(filter: self.filters.value)
        filterViewModel?.filtersSelected.bind(onNext: { [unowned self] filter in
            self.filters.accept(filter)
        }).disposed(by: bag)
        fetchData()
    }
    
    func fetchData() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self] _ in
            var items: [String] = []
            for n in 1...3 {
                items.append("item \(n)")
            }
            self?.data.accept(items)
        }
    }
    
}
