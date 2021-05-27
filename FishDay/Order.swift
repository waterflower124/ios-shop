//
//  Order.swift
//  FishDay
//
//  Created by Anas Sherif on 3/18/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import UIKit
import ObjectMapper

class Order: NSObject, Mappable {

    override init() {
        
    }
    
    var id: Int?
    var total: String?
    var subTotal: String?
    var tax: String?
    var delivery: String?
    var status: Int?
    var createdAt: String?
    var orderItems: [OrderItem]?
    var userPhoneNumber: String?
    var userFullName: String?
    var address: String?
    var notes: String?
    var address_lat: Double?
    var address_long: Double?
    var payment_method: String?
    var payment_status: String?
    var verification_code: String?
    var target_url: String?
    
    required init(map:Map) {
        
    }
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.total <- map["total"]
        self.subTotal <- map["subtotal"]
        self.status <- map["status"]
        self.createdAt <- map["created_at"]
        self.orderItems <- map["cart_items"]
        self.userPhoneNumber <- map["user_phone_number"]
        self.userFullName <- map["user_full_name"]
        self.address_lat <- map["address_lat"]
        self.address_long <- map["address_long"]
        self.address <- map["address"]
        self.tax <- map["tax"]
        self.delivery <- map["delivery"]
        self.notes <- map["notes"]
        self.payment_method <- map["payment_method"]
        self.payment_status <- map["payment_status"]
        self.verification_code <- map["verification_code"]
        self.target_url <- map["target_url"]
    }
}
