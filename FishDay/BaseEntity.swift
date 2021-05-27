//
//  BaseEntity.swift
//  FishDay
//
//  Created by Anas Sherif on 3/19/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import UIKit
import ObjectMapper

class BaseEntity: NSObject, Mappable {


    var status: String?
    var message: String?
    var code: Int?
    required init(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.code <- map["code"]
        self.status <- map["status"]
        self.message <- map["message"] 
    }
}
