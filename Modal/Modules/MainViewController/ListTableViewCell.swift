//
//  ListTableViewCell.swift
//  Modal
//
//  Created by Bruno Alves on 23/08/20.
//  Copyright © 2020 Bruno Alves. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var stars: UILabel!
    
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func setupCell(with item: Item) {
        self.title.text = item.fullName
        let selectedView = UIView()
        selectedView.backgroundColor = .clear
        self.selectedBackgroundView = selectedView
        
        self.followersLabel.text = String(item.watchersCount)
        self.forksLabel.text = String(item.forksCount)
        
        self.dateLabel.text = item.createdDateTime
        
        self.stars.text = String(item.stargazersCount)
        
        DispatchQueue.global().async {
            guard let url = URL(string: item.owner.avatarURL) else { return }
            let imageData = try? NSData(contentsOf: url, options: .dataReadingMapped) as Data
            DispatchQueue.main.async {
                self.avatarImage.image = UIImage(data: imageData ?? Data())
            }
        }
    }
}
