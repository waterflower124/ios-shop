//
//  Category.swift
//  FishDay
//
//  Created by Anas Sherif on 3/4/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import Foundation
import ObjectMapper
class Category : Mappable {
    
    var id: Int?
    var name: String?
    var description: String?
    var additional_info: String?
    var isSelected = false
    
    required init(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.name <- map["name"]
        self.description <- map["description"]
        self.additional_info <- map["additional_info"]
    }
}
