//
//  ResponseEntity.swift
//  FishDay
//
//  Created by Anas Sherif on 2/24/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import Foundation
import ObjectMapper

class ResponseEntity : Mappable
{
    var data: [Product]?
    
    required init(map:Map) {
        
    }
    func mapping(map: Map) {
        data <- map["data"]
    }
}
