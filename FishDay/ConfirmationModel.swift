//
//  ConfirmationModel.swift
//  FishDay
//
//  Created by Anas Sherif on 3/12/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class ConfirmationModel : NSObject
{
    var verify_url = "verifications"
    var order_url = "orders"
//    var apiManager: ApiManager?
    var confirmationProtocol: ConfirmationProtocol?
    
//    override init() {
//        apiManager = ApiManager()
//    }
    
    public func verify(order: Order, user: User, register: Bool){
        if !register {
            let userJson = Mapper().toJSON(order)
            let userBody = ["order" : userJson]
            print(userBody)
            
    //        Alamofire.request(Constant.BASE_URL + url, method: .post, parameters: userBody, encoding: JSONEncoding.default, headers: ApiManager.headers).responseJSON{
            Alamofire.request(Constant.BASE_URL + order_url, method: .post, parameters: userBody, encoding: JSONEncoding.default, headers: ApiManager.getHeaders()).responseJSON{
                response in
                print(response)
                
                if response.result.isSuccess {
                    let jsonRes = response.value as! NSDictionary
                    print (jsonRes)
                    
                    let status = jsonRes["status"] as! String
                    
                    switch status {
                    case "success":
                        let completeOrderJson = jsonRes["data"]
                        let order = Mapper<Order>().map(JSON: completeOrderJson as! [String : Any])
                        order?.target_url = jsonRes["target_url"] as? String
                        self.confirmationProtocol?.onCompleteOrderSuccess(order: order!)
                        break
                    case "fail":
    //                    let message = jsonRes["message"] as! String
    //                    let message = "Error while verifying account"
    //                    self.confirmationProtocol?.onConfirmationError(message: message )
                        var message = "";
                        if let code = jsonRes["code"] as? Int
                        {
                            //  code == 1: no matching verification code
                            //  code == 2: got to confirm
                            //  code == 3:
                            
                            if code == 1 {
                                message = "verify_code_wrong".localized
                                
                            } else {
                                message = "error_message".localized
                            }
                        } else {
    //                        let message = jsonRes["message"] as! String
                            message = "error_message".localized
                            
                        }
                        self.confirmationProtocol?.onCompleteOrderError(message: message )
                        break
                    default:
                        break
                    }
                    
                } else {
                    self.confirmationProtocol?.onConfirmationError(message: "error_message".localized)
                }
            }
        } else {
            let userJson = Mapper().toJSON(user)
            let userBody = ["user" : userJson]
            Alamofire.request(Constant.BASE_URL + verify_url, method: .post, parameters: userBody, encoding: JSONEncoding.default, headers: ApiManager.headers).responseJSON{
                response in
                
                if response.result.isSuccess {
                    let jsonRes = response.value as! NSDictionary
                    print (jsonRes)
                    
                    let status = jsonRes["status"] as! String
                    
                    switch status {
                    case "success":
                        let userJson = jsonRes["data"]
                        let user = Mapper<User>().map(JSON: userJson as! [String : Any])
                        self.confirmationProtocol?.onConfirmationSuccess(user: user!)
                        break
                    case "fail":
                        var message = "";
                        if let code = jsonRes["code"] as? Int
                        {
                            //  code == 1: no matching verification code
                            //  code == 2: got to confirm
                            //  code == 3:
                            
                            if code == 1 {
                                message = "verify_code_wrong".localized
                                
                            } else {
                                message = "error_message".localized
                            }
                        } else {
    //                        let message = jsonRes["message"] as! String
                            message = "error_message".localized
                            
                        }
                        self.confirmationProtocol?.onConfirmationError(message: message )
                        break
                    default:
                        break
                    }
                    
                }else{
                    self.confirmationProtocol?.onConfirmationError(message: "error_message".localized)
                }
            }
        }
    }
}
