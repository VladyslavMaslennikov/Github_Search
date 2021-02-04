//
//  RepositoryCell.swift
//  Github_Search
//
//  Created by Vladyslav on 04.02.2021.
//

import UIKit

class RepositoryCell: UITableViewCell {

    @IBOutlet weak var repositoryTitle: UILabel!
    @IBOutlet weak var numberOfStarsTitle: UILabel!
    @IBOutlet weak var starImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            let view = UIView()
            view.backgroundColor = .white
            selectedBackgroundView = view
        }
    }
    
}
