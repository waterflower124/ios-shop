//
//  MenuTableViewCell.swift
//  FishDay
//
//  Created by Anas Sherif on 2/20/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    var menu: Menu? {
        didSet{
            self.updateUI()
        }
    }
    
    func updateUI(){
        self.nameLabel?.text = menu?.name
        self.iconImageView?.image = menu?.icon
        
//        self.nameLabel.layer.shadowColor = UIColor.black.cgColor
//        self.nameLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
//        self.nameLabel.layer.shadowRadius = 6
//        self.nameLabel.layer.shadowOpacity = 1
    }
}
