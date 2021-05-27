//
//  OrderStatusProtocol.swift
//  FishDay
//
//  Created by Khaled Alswaidan on 14/08/2019.
//  Copyright © 2019 Anas Sherif. All rights reserved.
//


import UIKit

protocol OrderStatusProtocol {
    
    func onGettingLastOrderSuccess(order: Order)
    func onGettingLastOrderError(message: String)
    
   
    
}
