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
        prepareObservables()
        prepareNavigationBar()
    }

    private func prepareObservables() {
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
                var newFilters: [Filter] = []
                newFilters.append(viewModel.filters.value[indexPath.row])
                self.viewModel?.filtersSelected.accept(newFilters)
                for cell in self.tableView.visibleCells {
                    cell.accessoryType = .none
                }
                self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            }
        }.disposed(by: bag)
    }

    private func prepareNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: String.localize("search_view_controller_clear_filter"), style: .done, target: self, action: #selector(clearFilters))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close))
    }

    @objc private func clearFilters() {
        self.viewModel?.filtersSelected.accept([])
        tableView.reloadData()
    }

    @objc private func close() {
        self.dismiss(animated: true, completion: nil)
    }
}
