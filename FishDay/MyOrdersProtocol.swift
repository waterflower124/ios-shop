//
//  MyOrdersProtocol.swift
//  FishDay
//
//  Created by Anas Sherif on 3/20/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import UIKit

protocol MyOrdersProtocol {
    func onGettingMyOrdersSuccess(orders: [Order])
    func onGettingMyOrdersError(message: String)
}
