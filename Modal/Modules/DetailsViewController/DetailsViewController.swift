//
//  DetailsViewController.swift
//  Modal
//
//  Created by Bruno Alves on 20/08/20.
//  Copyright © 2020 Bruno Alves. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DetailsViewController: UIViewController {

    private var bag = DisposeBag()

    var viewModel: DetailsViewModel?

    @IBOutlet weak var languageTitleLabel: UILabel! {
        didSet {
            languageTitleLabel.text = String.localize("details_language_label")
        }
    }
    @IBOutlet weak var subscribersTitleLabel: UILabel! {
        didSet {
            subscribersTitleLabel.text = String.localize("details_subscribers_label")
        }
    }
    @IBOutlet weak var starsTitleLabel: UILabel! {
        didSet {
            starsTitleLabel.text = String.localize("details_stars_label")
        }
    }

    @IBOutlet weak var repoImage: UIImageView!
    @IBOutlet weak var repositoryName: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var subscribersLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel?.viewTitle ?? String()
        prepareObservers()
    }

    private func prepareObservers() {
        viewModel?.repoName.bind(onNext: { [weak self] value in
            DispatchQueue.main.async {
                self?.repositoryName.text = value
            }
        }).disposed(by: bag)

        viewModel?.language.bind(onNext: { [weak self] value in
            DispatchQueue.main.async {
                self?.languageLabel.text = value
            }
        }).disposed(by: bag)

        viewModel?.subscribers.bind(onNext: { [weak self] value in
            DispatchQueue.main.async {
                self?.subscribersLabel.text = value
            }
        }).disposed(by: bag)

        viewModel?.stars.bind(onNext: { [weak self] value in
            DispatchQueue.main.async {
                self?.starsLabel.text = value
            }
        }).disposed(by: bag)

        viewModel?.description.bind(onNext: { [weak self] value in
            DispatchQueue.main.async {
                self?.descriptionLabel.text = value
            }
        }).disposed(by: bag)

        viewModel?.repoImage.bind(onNext: { [weak self] value in
            DispatchQueue.main.async {
                self?.repoImage.image = value
            }
        }).disposed(by: bag)
    }
}
