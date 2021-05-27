//
//  HomeProtocol.swift
//  FishDay
//
//  Created by Anas Sherif on 3/23/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import UIKit

protocol HomeProtocol {
    
    func onGettingProductsSuccess(products: [Product])
    func onGettingProductsError(message: String)
    
    func onGettingOffersSuccess(products: [Product])
    func onGettingOffersError(message: String)
    
    func onGettingCategoriesSuccess(categories: [Category])
    func onGettingCategoriesError(message: String)
    
//    func onGettingLastOrderSuccess(order: Order)
//    func onGettingLastOrderError(message: String)
    
    func onGettingMeterSuccess(meter: Meter)
    func onGettingMeterError(message: String)
    
    func openCart()

}
