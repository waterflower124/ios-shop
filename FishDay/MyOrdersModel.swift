//
//  MyOrdersModel.swift
//  FishDay
//
//  Created by Anas Sherif on 3/20/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class MyOrdersModel: NSObject {

    let myOrderUrl = "orders"
    var myOrdersProtocol: MyOrdersProtocol?
    
    
    public func getMyOrders(){
        
        Alamofire.request(Constant.BASE_URL + myOrderUrl, method: .get, encoding: JSONEncoding.default, headers: ApiManager.getHeaders()).responseJSON{
            response in
            print(response)
            
            if response.result.isSuccess {
                let jsonRes = response.value as! NSDictionary
                print (jsonRes)
                
                let status = jsonRes["status"] as! String
                switch status {
                case "success":
                    let myOrdersJson = jsonRes["data"]
                    let orders = Mapper<Order>().mapArray(JSONObject: myOrdersJson)
                    
                    self.myOrdersProtocol?.onGettingMyOrdersSuccess(orders: orders!)
                    break
                case "fail":
                    let message = jsonRes["message"] as! String
                    self.myOrdersProtocol?.onGettingMyOrdersError(message: message)
                    break
                default:
                    break
                }
            }else{
                self.myOrdersProtocol?.onGettingMyOrdersError(message: "Errorrr")
            }
        }
    }
}
