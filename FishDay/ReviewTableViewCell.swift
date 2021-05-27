//
//  ReviewTableViewCell.swift
//  FishDay
//
//  Created by Water Flower on 1/24/21.
//  Copyright © 2021 Anas Sherif. All rights reserved.
//

import UIKit
import Cosmos

class ReviewTableViewCell: UITableViewCell {

    @IBOutlet var ratingView: CosmosView!
    @IBOutlet var reviewLabel: UILabel!
    @IBOutlet var avatarImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
