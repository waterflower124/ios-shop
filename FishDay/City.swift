//
//  City.swift
//  FishDay
//
//  Created by Anas Sherif on 3/27/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import UIKit
import ObjectMapper

class City: NSObject, Mappable {

    var id: Int?
    var name: String?
    
    
    required init(map:Map) {
        
    }
    
    func mapping (map:Map){
        self.id <- map["id"]
        self.name <- map["name"]
    }
}
