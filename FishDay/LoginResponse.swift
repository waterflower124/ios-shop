//
//  LoginResponse.swift
//  FishDay
//
//  Created by Anas Sherif on 3/6/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import UIKit
import ObjectMapper
class LoginResponse: NSObject, Mappable {

    var status: String?
    var message:String?
    
    required init(map:Map) {
        
    }
    
    func mapping(map: Map) {
        self.status <- map["status"]
        self.message <- map["message"]
    }
}
