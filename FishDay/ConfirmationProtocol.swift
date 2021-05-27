//
//  ConfirmationProtocol.swift
//  FishDay
//
//  Created by Anas Sherif on 3/12/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import Foundation
protocol ConfirmationProtocol {
    func onConfirmationSuccess(user: User)
    func onConfirmationError(message: String)
    
    func onCompleteOrderSuccess(order: Order)
    func onCompleteOrderError(message: String)
}
