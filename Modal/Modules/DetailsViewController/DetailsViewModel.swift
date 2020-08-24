//
//  DetailsViewMode.swift
//  Modal
//
//  Created by Bruno Alves on 24/08/20.
//  Copyright © 2020 Bruno Alves. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DetailsViewModel {

    private var repo: String
    private var bag = DisposeBag()

    lazy private var worker = GitHubWorker()

    var repoImage = BehaviorRelay<UIImage>(value: UIImage())
    var repoName = BehaviorRelay<String>(value: "")
    var language = BehaviorRelay<String>(value: "")
    var subscribers = BehaviorRelay<String>(value: "")
    var stars = BehaviorRelay<String>(value: "")
    var description = BehaviorRelay<String>(value: "")

    init(repo: String) {
        self.repo = repo
        fetchRepositoryInfo()
    }

    var viewTitle: String {
        return self.repo
    }

    private func fetchRepositoryInfo() {
        worker.fetchRepositoryDetails(repoName: self.repo, success: { [weak self] repository in
            self?.repoName.accept(repository.name)
            self?.language.accept(repository.language ?? String())
            self?.subscribers.accept(String(repository.subscribersCount))
            self?.stars.accept(String(repository.stargazersCount))
            self?.description.accept(repository.repositoryDetailsDescription)

            DispatchQueue.global().async {
                guard let url = URL(string: repository.owner.avatarURL) else { return }
                let imageData = try? NSData(contentsOf: url, options: .dataReadingMapped) as Data
                DispatchQueue.main.async {
                    self?.repoImage.accept(UIImage(data: imageData ?? Data()) ?? UIImage())
                }
            }
        }) { error in
            print(error)
        }
    }
}
