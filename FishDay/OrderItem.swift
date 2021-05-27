//
//  OrderItem.swift
//  FishDay
//
//  Created by Anas Sherif on 3/18/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import UIKit
import ObjectMapper
class OrderItem: NSObject, Mappable {
    
    var id: Int?
    var orderId: Int?
    var productId: Int?
    var product: Product?
    var quantity: Int?
    var unitPrice: String?
    var totalPrice: String?
    var quantityType: Int?
    var cuttingWay: Int?
    var seasoning: Int?
    var packaging: Int?
    
    override init() {
        
    }
    required init(map:Map) {
        
    }
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.orderId <- map["order_id"]
        self.productId <- map["product_id"]
        self.product <- map["product"]
        self.quantity <- map["quantity"]
        self.unitPrice <- map["unit_price"]
        self.totalPrice <- map["total_price"]
        self.quantityType <- map["quantity_type"]
        self.cuttingWay <- map["cleaning_type"]
        self.seasoning <- map["seasoning"]
        self.packaging <- map["packaging"]
    }
}
