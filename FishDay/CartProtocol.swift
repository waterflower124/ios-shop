//
//  CartProtocol.swift
//  FishDay
//
//  Created by Anas Sherif on 3/16/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import UIKit

protocol CartProtocol{
    
    func onGettingCartUpdateSuccess(product: Product)
    func onGettingCartUpdateError(message: String)

    func onPlaceOrderSuccess(order: Order)
    func onPlaceOrderError(message: String, product: Product)
    
    func onDeleteOrderItemSuccess(message: String)
    func onDeleteOrderItemError(message: String)
    
    
    func onIncreaseQuantity(orderItem: OrderItem, index: Int);
    func onDecreaseQuantity(orderItem: OrderItem, index: Int);
    func onDeleteItem(orderItem: OrderItem, index: Int);
    
}
