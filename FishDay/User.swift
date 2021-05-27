//
//  User.swift
//  FishDay
//
//  Created by Anas Sherif on 3/6/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import UIKit
import ObjectMapper
class User: NSObject, Mappable {

    
    override init() {
        
    }
    var id: Int?
    var name: String?
    var mobileNumber: String?
    var code: String?
    var authToken: String?
    var cityId: Int?
    var device_token: String?
    
    required init(map:Map) {
        
    }
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.mobileNumber <- map["mobile_number"]
        self.code <- map["verification_code"]
        self.authToken <- map["auth_token"]
        self.cityId <- map["city_id"]
        self.device_token <- map["device_token"]
    }
    
}
