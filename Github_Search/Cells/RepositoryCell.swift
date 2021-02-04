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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
