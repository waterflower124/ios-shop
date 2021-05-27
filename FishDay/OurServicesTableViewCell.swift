//
//  OurServicesTableViewCell.swift
//  FishDay
//
//  Created by Medhat Mohamed on 6/17/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import UIKit

class OurServicesTableViewCell: UITableViewCell {

    @IBOutlet weak var orderNumberLabel: UILabel!
    
    @IBOutlet weak var orderDateLabel: UILabel!
    
    @IBOutlet weak var orderImage: UIImageView!
    @IBOutlet weak var orderButton: UIButton!

    var order: Product? {
        didSet{
            self.updateUI()
        }
    }
    
    func updateUI(){
        self.orderNumberLabel.text = "\(order?.name ?? "")"
        //        self.orderDateLabel.text = order?.createdAt?.toSupportDate().dateString
        self.orderDateLabel.text = "\(order?.desc ?? "")"
        
        if order?.images != nil && (order?.images?.count)! > 0 {
            if ((order?.images?[0].small) != nil) {
                let downloadURL = URL(string: (order?.images?[0].small)!)
                if downloadURL != nil {
                    self.orderImage.af_setImage(withURL: downloadURL!)
                } else {
                    self.orderImage.image = #imageLiteral(resourceName: "fish")
                }
            }
        }
    }

}
