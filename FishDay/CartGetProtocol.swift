//
//  CartGetProtocol.swift
//  FishDay
//
//  Created by Water Flower on 9/18/20.
//  Copyright © 2020 Anas Sherif. All rights reserved.
//

import Foundation

protocol CartGetProtocol {
    
    func onGettingCartSuccess(order: Order)
    func onGettingCartError(message: String)
  
}
