//
//  CompleteOrderProtocol.swift
//  FishDay
//
//  Created by Anas Sherif on 3/27/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import Foundation
protocol CompleteOrderProtocol {
    
    func onCompleteOrderSuccess(order: Order)
    func goToConfirmation()
    func onCompleteOrderError(message: String)
}
