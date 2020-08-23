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
    
    var filterViewModel: FilterViewModel!
    private var bag = DisposeBag()
    
    private(set) var data = BehaviorRelay<[MainViewModel.MainViewItem]>(value: [])
    
    lazy private var worker = GitHubWorker()
    
    var filters = BehaviorRelay<[Filter]>(value: [])
    
    var queryItems = BehaviorRelay<[URLQueryItem]>(value: [])
//    var searchTerm: BehaviorRelay<URLQueryItem>?
    
    
    struct MainViewItem {
        var title: String { return item.fullName }
        var stars: String {
            guard let stars = item.stargazersCount else  { return String() }
            return String(stars)
        }
        var followers: String {
            guard let followers = item.watchersCount else { return String() }
            return String(followers)
        }
        var forks: String {
            guard let forks = item.forksCount else { return String() }
            return String(forks)
            
        }
        var date: String { return item.createdDateTime }
        var imageUrl: String { return item.owner.avatarURL }
        
        private(set) var item: Repository
        
        init(item: Repository) {
            self.item = item
        }
    }
    
    init() {
        self.filterViewModel = FilterViewModel(filter: self.filters.value)
        filterViewModel?.filtersSelected.bind(onNext: { [unowned self] filter in
            self.filters.accept(filter)
        }).disposed(by: bag)
        
        fetchInitialData()
    }
    
    func fetchInitialData() {
        worker.fetchListRepositories(success: { [weak self] items in
            var viewItems: [MainViewItem] = []
            for item in items {
                viewItems.append(MainViewItem(item: item))
            }
            self?.data.accept(viewItems)
        }) { [weak self] error in
            self?.data.accept([])
        }
    }
    
    private func performSearchFetch() {
        self.worker.fetchSearch(queryItems: self.queryItems.value, page: 1, success: { [weak self] search in
            var viewItems: [MainViewItem] = []
            for item in search.items {
                viewItems.append(MainViewItem(item: item))
            }
            self?.data.accept(viewItems)
        }) { [weak self] error in
            self?.data.accept([])
        }
    }

    func fetchData(query: String) {
        self.data.accept([])
        let searchTerm = URLQueryItem(name: "q", value: query)
        var q = queryItems.value
        q.removeAll { $0.name == "q" }
        q.append(searchTerm)
        self.queryItems.accept(q)
        performSearchFetch()
    }
    
    func fetchData(sort: Filter?) {
        self.data.accept([])
        var q = queryItems.value
        q.removeAll { $0.name == "sort" }
        if let sort = sort?.key {
            let searchTerm = URLQueryItem(name: "sort", value: sort)
            q.append(searchTerm)
        }
        self.queryItems.accept(q)
        performSearchFetch()
    }
    
    func fetchData(order: Sorting) {
        self.data.accept([])
        let searchTerm = URLQueryItem(name: "order", value: order.key)
        var q = queryItems.value
        q.removeAll { $0.name == "order" }
        q.append(searchTerm)
        self.queryItems.accept(q)
        performSearchFetch()
    }
    
}
