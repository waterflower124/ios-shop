//
//  LoginProtocol.swift
//  FishDay
//
//  Created by Anas Sherif on 3/6/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import Foundation
protocol LoginProtocol {
    
    func onLoginSuccess(user: User)
    func onLoginError(message: String)
    
    func onLoginGuestSuccess(user: User)
    func onLoginGuestError(message: String)
    
    func onGettingCitiesSuccess(cities: [City])
    func onGettingCitiesError(message: String)
}
