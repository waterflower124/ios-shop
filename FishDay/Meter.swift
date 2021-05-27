//
//  Meter.swift
//  FishDay
//
//  Created by Anas Sherif on 3/27/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import UIKit
import ObjectMapper

class Meter: NSObject, Mappable {

    var id: Int?
    var percentage: Int?
    
    required init(map:Map) {
        
    }
    
    func mapping (map:Map){
        self.id <- map["id"]
        self.percentage <- map["percentage"]
    }
}
