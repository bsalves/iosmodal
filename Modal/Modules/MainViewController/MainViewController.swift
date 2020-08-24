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

    @IBOutlet weak var orderSegmentedControll: UISegmentedControl! {
        didSet {
            for (index, _) in self.viewModel.filterViewModel.order.value.enumerated() {
                let title = viewModel.filterViewModel.order.value[index].describing
                orderSegmentedControll.setTitle(String.localize(title), forSegmentAt: index)
            }
        }
    }
    @IBOutlet weak var input: UITextField! {
        didSet {
            input.delegate = self
            input.placeholder = String.localize("search_txt_field_placeholder")
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
            tableView.rowHeight = 201
            tableView.refreshControl = self.refreshControll
            refreshControll.addTarget(self, action: #selector(self.updateList), for: .valueChanged)
        }
    }
    @IBOutlet weak var currentFiltersCollectionView: FilterCollectionView! {
        didSet {
            currentFiltersCollectionView.viewModel = self.viewModel
        }
    }
    @IBOutlet weak var currentFilterHeightConstraint: NSLayoutConstraint!

    var refreshControll = UIRefreshControl()

    private var bag = DisposeBag()
    private var cellIdentifier = "cell"
    private var viewModel = MainViewModel()
    private var isLoading = false

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.title = String.localize("main_view_title")
        setup()
        input.becomeFirstResponder()
    }

    private func setup() {
        prepareObservables()
        prepareNavigationBar()
        Observables.keyboardHeight().observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] (value) in
            self?.view.frame = CGRect(x: 0, y: 0, width: self?.view.frame.width ?? 0, height: self?.view.frame.height ?? 0 - value)
        }).disposed(by: bag)
    }

    private func prepareNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: String.localize("main_view_filter_button"), style: .plain, target: self, action: #selector(openFilter))
    }

    private func prepareObservables() {
        self.isLoading = true
        viewModel.data.bind(to: tableView.rx.items) { [unowned self] table, index, element in
            self.isLoading = false
            self.tableView.isUserInteractionEnabled = true
            self.refreshControll.endRefreshing()
            if let cell = self.tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier) as? ListTableViewCell {
                cell.setupCell(with: element)
                return cell
            }
            return UITableViewCell(style: .default, reuseIdentifier: self.cellIdentifier)
        }
        .disposed(by: bag)

        viewModel.filterViewModel.filtersSelected.bind(onNext: { [unowned self] filters in
            self.viewModel.fetchData(sort: filters.first)
            self.currentFilterHeightConstraint.constant = (self.viewModel.filterViewModel.filtersSelected.value.isEmpty) ? 0 : 44
            self.view.layoutIfNeeded()
        }).disposed(by: bag)

        tableView.rx.itemSelected.bind { [unowned self] indexPath in
            self.pushDetailsViewController(repoName: self.viewModel.data.value[indexPath.row].title)
        }.disposed(by: bag)

        tableView.rx.contentOffset.bind(onNext: { point in
            if !self.isLoading {
                if self.tableView.isNearBottomEdge() && !self.isLoading {
                    self.tableView.isUserInteractionEnabled = false
                    self.loadNextPage()
                }
                self.isLoading = true
            }
        }).disposed(by: bag)

        orderSegmentedControll.rx.selectedSegmentIndex.bind { [unowned self] index in
            let selectedOrder = self.viewModel.filterViewModel.order.value[index]
            self.viewModel.fetchData(order: selectedOrder)
            self.viewModel.filterViewModel.orderBy.accept(selectedOrder)
        }.disposed(by: bag)

        self.input.rx.controlEvent([.editingDidEnd]).asObservable().bind(onNext: { _ in
            self.viewModel.fetchData(query: self.input.text ?? String())
        }).disposed(by: bag)
    }

    private func loadNextPage() {
        self.isLoading = true
        viewModel.nextPage()
    }

    private func pushDetailsViewController(repoName: String) {
        let detailsViewController = DetailsViewController()
        detailsViewController.viewModel = viewModel.detailsViewModel(repo: repoName)
        navigationController?.pushViewController(detailsViewController, animated: true)
    }

    @objc private func openFilter() {
        let filterViewController = FilterViewController()
        filterViewController.viewModel = viewModel.filterViewModel
        let filterNavigarionController = UINavigationController(rootViewController: filterViewController)
        present(filterNavigarionController, animated: true, completion: nil)
    }

    @objc func updateList() {
        viewModel.updateData()
    }
}
