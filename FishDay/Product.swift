//
//  Product.swift
//  FishDay
//
//  Created by Anas Sherif on 2/21/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import Foundation
import ObjectMapper

class Product : Mappable
{
    var id: Int?
    var name: String?
    var desc: String?
    var kiloPrice: String?
    var promotion_kilo_price: String?
    var piecePrice: String?
    var promotion_piece_price: String?
    var link: String?
    var text: String?
    var image: String?
    var images: [Image]?
    var category: Category?
    var quantity_type: String?
    var quantity_count: Int?
    var related_products: [Product]?
    var reviews: [Review]?

    init(name: String, desc: String, kiloPrice: String) {
        self.name = name
        self.desc = desc
        self.kiloPrice = kiloPrice
//        self.images = images
        
    }
    
    required init?(map:Map) {

    }

    func mapping(map: Map) {
        self.id <- map["id"]
        self.name <- map["name"]
        self.desc <- map["desc"]
        self.category <- map["category"]
        self.images <- map["images"]
        self.kiloPrice <- map["kilo_price"]
        self.promotion_kilo_price <- map["promotion_kilo_price"]
        self.piecePrice <- map["piece_price"]
        self.promotion_piece_price <- map["promotion_piece_price"]
        self.image <- map["image"]
        self.text <- map["text"]
        self.link <- map["link"]
        self.quantity_type <- map["quantity_type"]
        self.quantity_count <- map["quantity"]
        self.related_products <- map["related_products"]
        self.reviews <- map["reviews"]
    }

}
