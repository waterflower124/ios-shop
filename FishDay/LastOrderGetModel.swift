//
//  LastOrderGetModel.swift
//  FishDay
//
//  Created by Water Flower on 9/18/20.
//  Copyright © 2020 Anas Sherif. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
class LastOrderGetModel: NSObject {
    
 
    let lastOrderUrl = "orders/last_incomplete_order"
    var lastOrderGetProtocol : LastOrderGetProtocol?


    func getLastOrder(){
        
        Alamofire.request(Constant.BASE_URL + lastOrderUrl, headers: ApiManager.getHeaders()).responseJSON{ response in
            print(response)
            if response.result.isSuccess {
                let jsonResponse = response.value as! NSDictionary
                if "\(jsonResponse["status"] ?? "")" == "fail" {
                    self.lastOrderGetProtocol?.onGettingLastOrderError(message: "error")
                  //  self.homeProtocol?.onGettingLastOrderError(message: "Errorrr")
                } else {
                    if let orderJson = jsonResponse["data"] as? NSDictionary {
                        let order = Mapper<Order>().map(JSONObject: orderJson)
                        self.lastOrderGetProtocol?.onGettingLastOrderSuccess(order: order!)
                    } else {
                        self.lastOrderGetProtocol?.onGettingLastOrderSuccess(order: nil)
                    }
                }
            } else {
               self.lastOrderGetProtocol?.onGettingLastOrderError(message: "error")
            }
        }
        
    }
}
