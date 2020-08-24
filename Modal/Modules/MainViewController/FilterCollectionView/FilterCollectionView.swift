//
//  FilterCollectionView.swift
//  Modal
//
//  Created by Bruno Alves on 20/08/20.
//  Copyright © 2020 Bruno Alves. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class FilterCollectionView: UIView {

    @IBOutlet var containerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!

    private var bag = DisposeBag()
    private var cellIdentifier = "cell"
    var viewModel: MainViewModel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        nibSetup()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(UINib(nibName: String(describing: FilterCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        prepareObservables()
    }

    private func prepareObservables() {
        viewModel?.filterViewModel.filtersSelected.bind(to: collectionView.rx.items(cellIdentifier: cellIdentifier, cellType: FilterCollectionViewCell.self)) { row, item, cell in
            cell.filterTitle?.text = item.describing
        }.disposed(by: bag)

        viewModel?.filterViewModel.filtersSelected.bind(to: collectionView.rx.items) { [unowned self] collectionView, index, item in
            if let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: IndexPath(row: index, section: 0)) as? FilterCollectionViewCell {
                cell.filterTitle?.text = item.describing
                return cell
            }
            return UICollectionViewCell()
        }
        .disposed(by: bag)

        collectionView.rx.itemSelected.bind { [unowned self] indexPath in
            guard let viewModel = self.viewModel else { return }
            var newFilters = viewModel.filterViewModel.filtersSelected.value
            newFilters.remove(at: indexPath.row)
            self.viewModel?.filterViewModel.filtersSelected.accept(newFilters)
        }.disposed(by: bag)
    }

    private func nibSetup() {
        containerView = loadViewFromNib()
        containerView.frame = bounds
        containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerView.translatesAutoresizingMaskIntoConstraints = true
        addSubview(containerView)
    }

    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as? UIView ?? UIView()
        return nibView
    }
}
