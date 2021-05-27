//
//  Review.swift
//  FishDay
//
//  Created by Water Flower on 1/24/21.
//  Copyright © 2021 Anas Sherif. All rights reserved.
//

import Foundation
import ObjectMapper

class Review: NSObject, Mappable {

    var id: Int?
    var rating: Double?
    var review: String?
    
    init(rating: Double, review: String) {
        self.rating = rating
        self.review = review
        
    }
    
    required init(map:Map) {
        
    }
    
    func mapping (map:Map){
        self.id <- map["id"]
        self.rating <- map["rating"]
        self.review <- map["review"]
    }
}

