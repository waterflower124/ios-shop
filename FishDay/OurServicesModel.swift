//
//  OurServicesModel.swift
//  FishDay
//
//  Created by Medhat Mohamed on 6/17/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class OurServicesModel: NSObject {
    
    let ourServicesUrl = "products/services"
    var myOrdersProtocol: OurServicesProtocol?
    
    
    public func getMyOrders(){
        
        Alamofire.request(Constant.BASE_URL + ourServicesUrl, method: .get, encoding: JSONEncoding.default, headers: ApiManager.getHeaders()).responseJSON{
            response in
            print(response)
            
            if response.result.isSuccess {
                let jsonRes = response.value as! NSDictionary
                print (jsonRes)
                
                let myOrdersJson = jsonRes["data"]
                let orders = Mapper<Product>().mapArray(JSONObject: myOrdersJson)
                self.myOrdersProtocol?.onGettingOurServicesSuccess(orders: orders!)

//                let status = jsonRes["status"] as! String
//                switch status {
//                case "success":
//                    let myOrdersJson = jsonRes["data"]
//                    let orders = Mapper<Order>().mapArray(JSONObject: myOrdersJson)
//                    
//                    break
//                case "fail":
//                    let message = jsonRes["message"] as! String
//                    self.myOrdersProtocol?.onGettingOurServicesError(message: message)
//                    break
//                default:
//                    break
//                }
            }else{
                self.myOrdersProtocol?.onGettingOurServicesError(message: "Errorrr")
            }
        }
    }

}
