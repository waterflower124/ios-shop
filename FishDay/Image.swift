//
//  Image.swift
//  FishDay
//
//  Created by Anas Sherif on 3/4/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import Foundation
import ObjectMapper
class Image : Mappable
{

    var small: String?
    var medium: String?
    var large: String?
    var original: String?
    
    init(small: String, medium: String, large: String, original: String) {
        self.small = small
        self.medium = medium
        self.large = large
        self.original = original
    }
    
    required init(map:Map) {
        
    }
    
    func mapping(map: Map) {
        self.small <- map["image_url_small"]
        self.medium <- map["image_url_medium"]
        self.large <- map["image_url_large"]
        self.original <- map["image_url_original"]
    }
    
}
