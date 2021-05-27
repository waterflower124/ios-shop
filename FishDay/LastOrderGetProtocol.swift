//
//  LastOrderGetProtocol.swift
//  FishDay
//
//  Created by Water Flower on 9/18/20.
//  Copyright © 2020 Anas Sherif. All rights reserved.
//

import Foundation

protocol LastOrderGetProtocol {
    
    func onGettingLastOrderSuccess(order: Order?)
    func onGettingLastOrderError(message: String)
    
   
    
}
