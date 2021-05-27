//
//  UserDefUtil.swift
//  FishDay
//
//  Created by Anas Sherif on 3/12/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import Foundation
import ObjectMapper
class UserDefUtil : NSObject
{
    public class func saveUser(user: User){
        let userDefaults = UserDefaults()
        let userString = Mapper().toJSONString(user)
        userDefaults.set(userString, forKey: Constant.USER)
    }
    
    public class func getUser() -> User{
        let userDefaults = UserDefaults()
        let userString = userDefaults.string(forKey: Constant.USER)
        let user = Mapper<User>().map(JSONString: userString!)
        return user!
        
    }
    
    public class func saveOrder(order: Order){
        let userDefaults = UserDefaults()
        let orderString = Mapper().toJSONString(order)
        userDefaults.set(orderString, forKey: Constant.ORDER)
    }
    
    public class func getOrder() -> Order{
        let userDefaults = UserDefaults()
        let orderStringg = userDefaults.string(forKey: Constant.ORDER)
        guard let orderString = orderStringg  else {
            return Order()
        }
        let order = Mapper<Order>().map(JSONString: orderString)
        return order!
        
    }
    
    public class func deleteOrder(order: Order){
        let userDefaults = UserDefaults()
        userDefaults.set(nil, forKey: Constant.ORDER)
    }
    
    public class func contains(key: String) -> Bool{
        let userDefauls = UserDefaults()
        return userDefauls.object(forKey: Constant.USER) != nil
        
    }
    public class func clearAllData(){
        let userDefaults = UserDefaults()
        userDefaults.removeObject(forKey: Constant.USER)
    }
    
    public class func saveUniversalProductID(productID: String) {
        let userDefaults = UserDefaults()
        userDefaults.set(productID, forKey: Constant.UNIVERSAL_PRODUCTID)
    }
    
    public class func getUniversalProductID() -> String {
        let userDefaults = UserDefaults()
        if let productID = userDefaults.string(forKey: Constant.UNIVERSAL_PRODUCTID) {
            return productID
        } else {
            return ""
        }
    }
}
