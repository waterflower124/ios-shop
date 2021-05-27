//
//  CreateOrderItemProtocol.swift
//  FishDay
//
//  Created by Anas Sherif on 3/27/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import UIKit

protocol CreateOrderItemProtocol{

    func onCreatingOrderItemSuccess(order: Order)
    func onCreatingOrderItemError(message: String)
}
