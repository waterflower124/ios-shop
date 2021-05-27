//
//  CreateOrderItemModel.swift
//  FishDay
//
//  Created by Anas Sherif on 3/27/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
class CreateOrderItemModel: NSObject {

    var createOrderItemProtocol: CreateOrderItemProtocol?
//    let createOrderItemUrl = "order_items/create_or_update"
    let createOrderItemUrl = "cart_items/create_or_update"
    
    func createOrderItem(orderItem: OrderItem){
        
        let orderItemJson = Mapper().toJSON(orderItem)
//        let orderItemBody = ["order_item" : orderItemJson]
        let orderItemBody = ["cart_item" : orderItemJson]
        print(orderItemBody)
        Alamofire.request(Constant.BASE_URL + createOrderItemUrl, method: .post, parameters: orderItemBody, encoding: JSONEncoding.default, headers: ApiManager.getHeaders()).responseJSON{
            response in
            print(response)
            
            if response.result.isSuccess {
                let jsonRes = response.value as! NSDictionary
                
                if let status = jsonRes["status"] as? String
                {
                    switch status {
                    case "success":
                        let orderJson = jsonRes["data"]
                        let order = Mapper<Order>().map(JSON: orderJson as! [String : Any])
                        self.createOrderItemProtocol?.onCreatingOrderItemSuccess(order: order!)
                        break
                    case "fail":
                        let message = jsonRes["message"] as! String
                        self.createOrderItemProtocol?.onCreatingOrderItemError(message: message)
                        break
                        
                    default:
                        
                        break
                    }
                }
                else
                {
                    let message = jsonRes["error"] as! String
                    self.createOrderItemProtocol?.onCreatingOrderItemError(message: message)
                }
            }else{
                self.createOrderItemProtocol?.onCreatingOrderItemError(message: "Errorrrrr")            }
        }
    }
    
}
