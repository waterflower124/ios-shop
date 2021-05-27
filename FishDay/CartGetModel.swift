//
//  CartGetModel.swift
//  FishDay
//
//  Created by Water Flower on 9/18/20.
//  Copyright © 2020 Anas Sherif. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
class CartGetModel: NSObject {
    
    let myOrderUrl = "orders"
  
    let cartUrl = "carts/show"
    var cartGetProtocol : CartGetProtocol?


    func getCart(){
        Alamofire.request(Constant.BASE_URL + cartUrl, headers: ApiManager.getHeaders()).responseJSON{ response in
            print(response)
            if response.result.isSuccess {
                let jsonResponse = response.value as! NSDictionary
                if "\(jsonResponse["status"] ?? "")" == "fail" {
                    self.cartGetProtocol?.onGettingCartError(message: "error")
                } else {
                    let orderJson = jsonResponse["data"]
                    let order = Mapper<Order>().map(JSONObject: orderJson)
                    self.cartGetProtocol?.onGettingCartSuccess(order: order!)
                }
            } else {
               self.cartGetProtocol?.onGettingCartError(message: "error")
            }
        }
        
    }
}
