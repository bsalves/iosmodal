//
//  FilterViewController.swift
//  Modal
//
//  Created by Bruno Alves on 20/08/20.
//  Copyright © 2020 Bruno Alves. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class FilterViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: "FilterTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        }
    }
    
    private var bag = DisposeBag()
    var viewModel: FilterViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.title = String.localize("search_view_controller_title")
        
        viewModel?.filters.bind(to: self.tableView.rx.items(cellIdentifier: "cell")) { row, item, cell in
            guard let viewModel = self.viewModel else { return }
            cell.textLabel?.text = item.describing
            if viewModel.filtersSelected.value.contains(item) {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }.disposed(by: bag)
        
        tableView.rx.itemSelected.bind { [unowned self] indexPath in
            guard let viewModel = self.viewModel else { return }
            if viewModel.filtersSelected.value.contains(viewModel.filters.value[indexPath.row]) {
                var newFilters = viewModel.filtersSelected.value
                newFilters.removeAll { $0 == viewModel.filters.value[indexPath.row] }
                self.viewModel?.filtersSelected.accept(newFilters)
                self.tableView.cellForRow(at: indexPath)?.accessoryType = .none
            } else {
                var newFilters = viewModel.filtersSelected.value
                newFilters.append(viewModel.filters.value[indexPath.row])
                self.viewModel?.filtersSelected.accept(newFilters)
                self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            }
            
        }.disposed(by: bag)
    }
}
