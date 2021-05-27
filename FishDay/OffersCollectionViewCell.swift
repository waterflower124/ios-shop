//
//  OffersCollectionViewCell.swift
//  FishDay
//
//  Created by Medhat Mohamed on 3/23/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import UIKit
import AlamofireImage

class OffersCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var orderNowButton: UIButton!
    
    
    var product: Product!{
        didSet{
            self.productNameLabel.text = product.text
            self.productPriceLabel.text = ""
            if product.image != nil {
                if (product.image != nil) {
                    let downloadURL = URL(string: product.image!)
                    if downloadURL != nil {
                        self.productImage.af_setImage(withURL: downloadURL!)
                    } else {
                        self.productImage.image = #imageLiteral(resourceName: "fish")
                    }
                }
            }
            
        }
    }
    
}
