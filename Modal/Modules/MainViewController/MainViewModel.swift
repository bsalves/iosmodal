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
    
    private(set) var data = BehaviorRelay<[Item]>(value: [])
    
    lazy private var worker = GitHubWorker()
    
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
        
        worker.fetch(success: { [weak self] search in
            self?.data.accept(search.items)
        }) { [weak self] failError in
            self?.data.accept([])
        }
    }
    
}
