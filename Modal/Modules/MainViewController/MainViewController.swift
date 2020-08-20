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
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
        }
    }
    @IBOutlet weak var currentFilters: FilterCollectionView!
    @IBOutlet weak var currentFilterHeightConstraint: NSLayoutConstraint!
    
    private var bag = DisposeBag()
    private var cellIdentifier = "cell"
    private var items = BehaviorRelay<[String]>(value: [])
    private var viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "MainViewController"
        setup()
    }
    
    private func setup() {
        prepareTableView()
        prepareObservables()
        
        Observables.keyboardHeight().observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] (value) in
            self?.view.frame = CGRect(x: 0, y: 0, width: self?.view.frame.width ?? 0, height: self?.view.frame.width ?? 0 - value)
        }).disposed(by: bag)
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
        
        currentFilters.filters.asObservable().subscribe(onNext: { [unowned self] filters in
            self.currentFilterHeightConstraint.constant = (self.currentFilters.filters.value.isEmpty) ? 0 : 44
            self.view.layoutIfNeeded()
        }).disposed(by: bag)
    }
    
    private func pushDetailsViewController(_ viewValue: String) {
        let detailsViewController = DetailsViewController()
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushDetailsViewController(items.value[indexPath.row])
    }
}

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let newText = textField.text {
            var values = items.value
            values.append(newText)
            items.accept(values)
            textField.text = nil
            textField.becomeFirstResponder()
        }
        return true
    }
}
