//
//  CategoriesCollectionViewCell.swift
//  FishDay
//
//  Created by Medhat Mohamed on 3/23/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import UIKit
import AlamofireImage

class CategoriesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryView: UIView!
    
    
    var category: Category!{
        didSet{
            self.categoryLabel.text = category.name
        }
    }

    
}
