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
    
    init() {
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
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { [weak self] _ in
            var items: [String] = self?.data.value ?? []
            for n in 4...10 {
                items.append("item \(n)")
            }
            self?.data.accept(items)
        }
    }
}
