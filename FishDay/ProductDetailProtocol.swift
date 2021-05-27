//
//  ProductDetailProtocol.swift
//  FishDay
//
//  Created by Water Flower on 9/20/20.
//  Copyright © 2020 Anas Sherif. All rights reserved.
//

import Foundation

protocol ProductDetailProtocol{
    
    func onGettingProductDetailSuccess(product: Product)
    func onGettingProductDetailError(message: String)

    
}
