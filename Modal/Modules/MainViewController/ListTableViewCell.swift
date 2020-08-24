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
    
    @IBOutlet weak var starsTitleLabel: UILabel! {
        didSet {
            starsTitleLabel.text = String.localize("list_tableviewcell_stars_title")
        }
    }
    @IBOutlet weak var followersTitleLabel: UILabel! {
        didSet {
            followersTitleLabel.text = String.localize("list_tableviewcell_followers_title")
        }
    }
    @IBOutlet weak var forksTitleLabel: UILabel! {
        didSet {
            forksTitleLabel.text = String.localize("list_tableviewcell_forks_title")
        }
    }
    @IBOutlet weak var dateTitleLabel: UILabel! {
        didSet {
            dateTitleLabel.text = String.localize("list_tableviewcell_date_title")
        }
    }
    
    
    override func prepareForReuse() {
        super.layoutSubviews()
        self.avatarImage.image = nil
    }
    
    func setupCell(with item: MainViewModel.MainViewItem) {
        self.title.text = item.title
        let selectedView = UIView()
        selectedView.backgroundColor = .clear
        self.selectedBackgroundView = selectedView
        
        self.followersLabel.text = item.followers
        self.forksLabel.text = item.forks
        self.dateLabel.text = item.date
        self.stars.text = item.stars
        
        DispatchQueue.global().async {
            guard let url = URL(string: item.imageUrl) else { return }
            let imageData = try? NSData(contentsOf: url, options: .dataReadingMapped) as Data
            DispatchQueue.main.async {
                self.avatarImage.image = UIImage(data: imageData ?? Data())
            }
        }
    }
}
