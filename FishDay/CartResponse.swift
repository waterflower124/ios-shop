//
//  CartResponse.swift
//  FishDay
//
//  Created by Anas Sherif on 3/18/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import UIKit
import ObjectMapper
class CartResponse: NSObject, Mappable {
    var data: Order?
    var status: String?
    var message: String?
    
    required init(map:Map) {
        
    }
    func mapping(map: Map) {
        data <- map["data"]
        status <- map["status"]
        message <- map["message"]
    }
}
