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
    var filters = BehaviorRelay<[String]>(value: ["Filto 1", "Filtro 2"])
    
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
        setupObservables()
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
            self.filters.accept([])
        }
    }
    
    private func setupObservables() {
        filters.bind(to: collectionView.rx.items(cellIdentifier: cellIdentifier, cellType: FilterCollectionViewCell.self)) { row, item, cell in
            cell.filterTitle?.text = item
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
