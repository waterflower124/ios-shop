//
//  MyOrdersTableViewCell.swift
//  FishDay
//
//  Created by Anas Sherif on 3/20/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import UIKit

class MyOrdersTableViewCell: UITableViewCell {

    @IBOutlet weak var orderNumberLabel: UILabel!
    
    @IBOutlet weak var orderDateLabel: UILabel!
    
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var orderNumberTitle: UILabel!
    @IBOutlet weak var orderTotalPrice: UILabel!
    var order: Order? {
        didSet{
            self.updateUI()
        }
    }
    
    func updateUI(){
        self.orderNumberLabel.text = "\(order?.id ?? 0)"
//        self.orderDateLabel.text = order?.createdAt?.toSupportDate().dateString
        self.orderDateLabel.text = "\(order?.createdAt?.toSupportDate().dayMonthString ?? "") at \(order?.createdAt?.toSupportDate().timeString ?? "")"

        self.orderTotalPrice.text = order?.subTotal
        self.currencyLabel.text = "SAR".localized
        self.orderNumberTitle.text = "OrderNumber".localized
    }
}
