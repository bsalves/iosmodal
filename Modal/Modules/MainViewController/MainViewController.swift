//
//  MainViewController.swift
//  Modal
//
//  Created by Bruno Alves on 20/08/20.
//  Copyright © 2020 Bruno Alves. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MainViewController: UIViewController {

    @IBOutlet weak var input: UITextField! {
        didSet {
            input.delegate = self
            input.placeholder = String.localize("search_txt_field_placeholder")
        }
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var currentFiltersCollectionView: FilterCollectionView! {
        didSet {
            currentFiltersCollectionView.viewModel = self.viewModel
        }
    }
    @IBOutlet weak var currentFilterHeightConstraint: NSLayoutConstraint!
    
    private var bag = DisposeBag()
    private var cellIdentifier = "cell"
    private var viewModel = MainViewModel()
    
    var items = BehaviorRelay<[String]>(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.title = String.localize("main_view_title")
        setup()
    }
    
    private func setup() {
        prepareTableView()
        prepareObservables()
        prepareNavigationBar()
        
        Observables.keyboardHeight().observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] (value) in
            self?.view.frame = CGRect(x: 0, y: 0, width: self?.view.frame.width ?? 0, height: self?.view.frame.width ?? 0 - value)
        }).disposed(by: bag)
    }
    
    private func prepareNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(openFilter))
    }
    
    private func prepareTableView() {
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }

    private func prepareObservables() {
        items.bind(to: tableView.rx.items(cellIdentifier: cellIdentifier, cellType: ListTableViewCell.self)) { row, item, cell in
            cell.textLabel?.text = item
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
        }.disposed(by: bag)
        
        viewModel.data.subscribe(onNext: { value in
            self.items.accept(value)
        }).disposed(by: bag)
        
        viewModel.filterViewModel.filtersSelected.bind(onNext: { [unowned self] filters in
            self.currentFilterHeightConstraint.constant = (self.viewModel.filterViewModel.filtersSelected.value.isEmpty) ? 0 : 44
            self.view.layoutIfNeeded()
        }).disposed(by: bag)
        
        tableView.rx.itemSelected.bind { [unowned self] indexPath in
            self.pushDetailsViewController(self.items.value[indexPath.row])
        }.disposed(by: bag)
    }
    
    private func pushDetailsViewController(_ viewValue: String) {
        let detailsViewController = DetailsViewController()
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    @objc private func openFilter() {
        let filterViewController = FilterViewController()
        filterViewController.viewModel = viewModel.filterViewModel
        let filterNavigarionController = UINavigationController(rootViewController: filterViewController)
        present(filterNavigarionController, animated: true, completion: nil)
    }
}
