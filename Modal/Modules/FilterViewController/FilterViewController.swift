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
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    private var filters = [
        "Estrelas",
        "Seguidores",
        "Data"
    ]
    
    private var orders = [
        "Crescente",
        "Decrescente"
    ]
    
    private var headerTitles = [
        "Filtros",
        "Ordem"
    ]
    
    var viewModel: FilterViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.title = String.localize("search_view_controller_title")
    }

}

extension FilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            if tableView.cellForRow(at: indexPath)?.accessoryType != .checkmark {
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                var selectedFilters = viewModel?.filtersSelected.value
                selectedFilters?.append(filters[indexPath.row])
                viewModel?.filtersSelected.accept(selectedFilters ?? [])
            } else {
                tableView.cellForRow(at: indexPath)?.accessoryType = .none
                var selectedFilters = viewModel?.filtersSelected.value
                selectedFilters?.removeAll { $0 == filters[indexPath.row] }
                viewModel?.filtersSelected.accept(selectedFilters ?? [])
            }
        } else if indexPath.section == 1 {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            viewModel?.orderBy.accept(orders[indexPath.row])
        }
    }
}

extension FilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        if indexPath.section == 0 {
            if viewModel?.filtersSelected.value.contains(filters[indexPath.row]) ?? false {
                cell.accessoryType = .checkmark
            }
            cell.textLabel?.text = filters[indexPath.row]
        } else if indexPath.section == 1 {
            cell.textLabel?.text = orders[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerTitles[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return filters.count
        } else if section == 1 {
            return orders.count
        }
        return 0
    }
}
