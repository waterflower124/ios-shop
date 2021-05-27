//
//  CartModel.swift
//  FishDay
//
//  Created by Anas Sherif on 3/18/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class CartModel: NSObject {
    
    let placeOrderUrlPrefix = "orders/" // PUT
    let placeOrderUrlSuffix = "/update_order_items"
    let deleteOrderItemUrl = "cart_items/" // DELETE
    
    let cartUpdateUrl = "carts/update_cart_items/" // PUT
    var cartProtocol: CartProtocol?
    
    public func placeOrder(orderId: Int, order: Order) {
        
        let orderJson = Mapper().toJSON(order)
        let orderBody = ["cart": orderJson]
        print(orderJson)
        
        Alamofire.request(Constant.BASE_URL + cartUpdateUrl, method: .put, parameters: orderBody, encoding: JSONEncoding.default, headers: ApiManager.getHeaders()).responseJSON{
            response in
            print(response)
            
            if response.result.isSuccess {
                let jsonRes = response.value as! NSDictionary
                print (jsonRes)
                
                let status = jsonRes["status"] as! String
                switch status {
                case "success":
                    let cartJson = jsonRes["data"]
                    let order = Mapper<Order>().map(JSON: cartJson as! [String : Any])
                    self.cartProtocol?.onPlaceOrderSuccess(order: order!)
                    break
                case "fail":
                    let message = jsonRes["message"] as! String
                    let cartJson = jsonRes["product"]
                    let product = Mapper<Product>().map(JSON: cartJson as! [String : Any])
                    self.cartProtocol?.onPlaceOrderError(message: message, product: product!)
                    break
                default:
                    break
                }
            }else{
                let product: Product? = nil
                self.cartProtocol?.onPlaceOrderError(message: "Errorrr", product: product!)
            }
        }
    }
    
    
    
    public func cartUpdate(orderId: Int, order: Order) {
        
        let orderJson = Mapper().toJSON(order)
        let orderBody = ["cart": orderJson]
        print(orderJson)
        
        Alamofire.request(Constant.BASE_URL + cartUpdateUrl, method: .put, parameters: orderBody, encoding: JSONEncoding.default, headers: ApiManager.getHeaders()).responseJSON{
            response in
            print(response)
            
            if response.result.isSuccess {
                let jsonRes = response.value as! NSDictionary
                print (jsonRes)
                
                let status = jsonRes["status"] as! String
                switch status {
                case "success":
                    let cartJson = jsonRes["data"]
                    let product = Mapper<Product>().map(JSON: cartJson as! [String : Any])
                    self.cartProtocol?.onGettingCartUpdateSuccess(product: product!)
                    break
                case "fail":
                    let message = jsonRes["message"] as! String
                    self.cartProtocol?.onGettingCartUpdateError(message: message)
                    break
                default:
                    break
                }
            }else{
                self.cartProtocol?.onGettingCartUpdateError(message: "Errorrr")
            }
        }
    }
  
    
    public func deleteOrderItem(orderItemId: Int){
        Alamofire.request(Constant.BASE_URL + deleteOrderItemUrl + "\(orderItemId)", method: .delete, encoding: JSONEncoding.default, headers: ApiManager.getHeaders()).responseJSON{
            response in
            print(response)
            
            if response.result.isSuccess {
                let jsonRes = response.value as! NSDictionary
                print (jsonRes)
                
                let status = jsonRes["status"] as! String
                switch status {
                case "success":
                    let message = jsonRes["message"] as! String
                    self.cartProtocol?.onDeleteOrderItemSuccess(message: message)
                    break
                case "fail":
                    let message = jsonRes["message"] as! String
                    self.cartProtocol?.onDeleteOrderItemError(message: message)
                    break
                default:
                    break
                }
            }else{
                self.cartProtocol?.onDeleteOrderItemError(message: "Errorrr")
            }
        }
    }
}
