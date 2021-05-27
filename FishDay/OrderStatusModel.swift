//
//  OrderStatusModel.swift
//  FishDay
//
//  Created by Khaled Alswaidan on 14/08/2019.
//  Copyright © 2019 Anas Sherif. All rights reserved.
//



import Foundation
import Alamofire
import ObjectMapper
class OrderStatusModel: NSObject {
    
    let myOrderUrl = "orders"
  
    let lastOrderUrl = "orders/last_incomplete_order"
    var orderStatusProtocol : OrderStatusProtocol?


func getLastOrder(){
    
    Alamofire.request(Constant.BASE_URL + lastOrderUrl, headers: ApiManager.getHeaders()).responseJSON{ response in
        print(response)
        if response.result.isSuccess {
            let jsonResponse = response.value as! NSDictionary
            if "\(jsonResponse["status"] ?? "")" == "500"
            {
                self.orderStatusProtocol?.onGettingLastOrderError(message: "error")
            } else {
                let orderJson = jsonResponse["data"]
                let order = Mapper<Order>().map(JSONObject: orderJson)
                self.orderStatusProtocol?.onGettingLastOrderSuccess(order: order!)
                
            }
        } else{
           self.orderStatusProtocol?.onGettingLastOrderError(message: "error")
        }
    }
    
}
}
