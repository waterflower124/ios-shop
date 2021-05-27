//
//  LoginModel.swift
//  FishDay
//
//  Created by Muhammad Kamal on 2/17/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
class LoginModel: NSObject
{
    let url = "users/signup"
    let citiesUrl = "cities"
    let registerGuestUrl = "users/create_guest"
    
    var apiManager: ApiManager?
    var loginProtocol: LoginProtocol?
    
    override init() {
        apiManager = ApiManager()
    }
    
    
    func getCities(){
        
        Alamofire.request(Constant.BASE_URL + citiesUrl, headers: ApiManager.headers).responseJSON{ response in
            
            if response.result.isSuccess {
                let jsonResponse = response.value as! NSDictionary
                let citiesJson = jsonResponse["data"]
                let cities = Mapper<City>().mapArray(JSONObject: citiesJson)
                
                self.loginProtocol?.onGettingCitiesSuccess(cities: cities!)
            }else{
                self.loginProtocol?.onGettingCitiesError(message: "Errorrr")
            }
        }
        
    }
    
    public func login(user: User){
        let userJson = Mapper().toJSON(user)
        let userBody = ["user" : userJson]
        
        print(userBody)
        
        Alamofire.request(Constant.BASE_URL + url, method: .post, parameters: userBody, encoding: JSONEncoding.default, headers: ApiManager.headers).responseJSON{
            response in
            print(response)
            
            if response.result.isSuccess {
                let jsonRes = response.value as! NSDictionary
                print (jsonRes)
                
                let status = jsonRes["status"] as! String
                switch status {
                    case "success":
                        let userJson = jsonRes["data"]
                        let user = Mapper<User>().map(JSON: userJson as! [String : Any])
                        self.loginProtocol?.onLoginSuccess(user: user!)
                    break
                    case "fail":
                        let message = jsonRes["message"] as! String
                    self.loginProtocol?.onLoginError(message: message )
                    break
                    
                default:
                
                    break
                }
                
            }else{
                self.loginProtocol?.onLoginError(message: "Errorrr")
            }
            
        }
    }
    
    public func loginGuest(user: User){
        
        let userJson = Mapper().toJSON(user)
        let userBody = ["user" : userJson]
        
        Alamofire.request(Constant.BASE_URL + registerGuestUrl, method: .post, parameters: userBody, encoding: JSONEncoding.default, headers: ApiManager.headers).responseJSON{
            response in
            print(response)
            
            if response.result.isSuccess {
                let jsonRes = response.value as! NSDictionary
                print (jsonRes)
                
                let status = jsonRes["status"] as! String
                switch status {
                case "success":
                    let userJson = jsonRes["data"]
                    let user = Mapper<User>().map(JSON: userJson as! [String : Any])
                    self.loginProtocol?.onLoginGuestSuccess(user: user!)
                    break
                case "fail":
                    let message = jsonRes["message"] as! String
                    self.loginProtocol?.onLoginGuestError(message: message )
                    break
                    
                default:
                    
                    break
                }
                
            }else{
                self.loginProtocol?.onLoginError(message: "Errorrr")
            }
            
            
        }
    }
}
