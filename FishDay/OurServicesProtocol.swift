//
//  OurServicesProtocol.swift
//  FishDay
//
//  Created by Medhat Mohamed on 6/17/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import UIKit

protocol OurServicesProtocol {
    func onGettingOurServicesSuccess(orders: [Product])
    func onGettingOurServicesError(message: String)
}

