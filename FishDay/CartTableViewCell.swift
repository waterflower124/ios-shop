//
//  CartTableViewCell.swift
//  FishDay
//
//  Created by Anas Sherif on 3/18/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var currencyTitleLabel: UILabel!
    @IBOutlet weak var priceTitleLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    var cartProtocol: CartProtocol?
    var indexPath: IndexPath?
    var orderItem: OrderItem? {
        didSet{
            self.updateUI()
        }
    }
    
    func updateUI(){
        self.priceTitleLabel.text = "Price".localized
        self.currencyTitleLabel.text = "SAR".localized
        self.productName.text = orderItem?.product?.name
        self.productPrice.text = orderItem?.totalPrice
        self.quantityLabel.text = "\(orderItem?.quantity ?? 0)"
        ApiManager.loadImage(imageView: self.productImage, imageUrl: (orderItem?.product?.images?[0].small)!)
    }
    @IBAction func increaseQuantity(_ sender: UIButton) {
        cartProtocol?.onIncreaseQuantity(orderItem: self.orderItem!, index: (self.indexPath?.row)!)
    }
    
    @IBAction func decreaseQuantity(_ sender: UIButton) {
        cartProtocol?.onDecreaseQuantity(orderItem: self.orderItem!, index: (self.indexPath?.row)!)
    }
    
    @IBAction func deleteItem(_ sender: UIButton) {
        cartProtocol?.onDeleteItem(orderItem: self.orderItem!, index: (self.indexPath?.row)!)
    }
    
    
}
