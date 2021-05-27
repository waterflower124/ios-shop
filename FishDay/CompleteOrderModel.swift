//
//  CompleteOrderModel.swift
//  FishDay
//
//  Created by Anas Sherif on 3/27/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
class CompleteOrderModel: NSObject {

    var completeOrderProtocol: CompleteOrderProtocol?
    let completeOrderUrl = "orders"
    
    func completeOrder(orderId: Int, order: Order){
        
        let completeOrderJson = Mapper().toJSON(order)
        let completeOrderBody = ["order" : completeOrderJson]
        print(completeOrderBody)
        print("//////////////////")
        
        Alamofire.request(Constant.BASE_URL + completeOrderUrl, method: .post, parameters: completeOrderBody, encoding: JSONEncoding.default, headers: ApiManager.getHeaders()).responseJSON{
            response in
            print(response)
            
            if response.result.isSuccess {
                let jsonRes = response.value as! NSDictionary
                
                let status = jsonRes["status"] as! String
                switch status {
                case "success":
                    let completeOrderJson = jsonRes["data"]
                    let order = Mapper<Order>().map(JSON: completeOrderJson as! [String : Any])
                    order?.target_url = jsonRes["target_url"] as? String
                    self.completeOrderProtocol?.onCompleteOrderSuccess(order: order!)
                    break
                case "fail":
                    if let code = jsonRes["code"] as? Int
                    {
                        //  code == 1: no matching verification code
                        //  code == 2: got to confirm
                        //  code == 3:
                        if code == 2 {
                            self.completeOrderProtocol?.goToConfirmation()
                        } else {
                            let message = jsonRes["message"] as! String
                            self.completeOrderProtocol?.onCompleteOrderError(message: message)
                        }
                    } else {
                        let message = jsonRes["message"] as! String
                        self.completeOrderProtocol?.onCompleteOrderError(message: message)
                    }
                    break
                    
                default:
                    
                    break
                }
                
            } else {
                self.completeOrderProtocol?.onCompleteOrderError(message: "error_message".localized)
            }
            
            
        }
        
    }
    
}
