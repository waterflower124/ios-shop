//
//  File.swift
//  FishDay
//
//  Created by Muhammad Kamal on 2/17/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import MOLH

class HomeModel: NSObject{
    
    var homeProtocol: HomeProtocol?
    var orderProtocol : MyOrdersProtocol?
    let productsUrl = "home"
    let offersUrl = "sliders"
    let categoriesUrl = "categories"
    let lastOrderUrl = "orders/last_incomplete_order"
//    let lastOrderUrl = "carts/show"
    let meterUrl = "meter"
    
    func getProducts(){
        
        var lang = "en";
        if MOLHLanguage.isArabic() {
            lang = "ar"
        }
        
        Alamofire.request(Constant.BASE_URL + productsUrl + "?locale=" + lang, headers: ApiManager.getHeaders()).responseJSON{ response in
            
            print(response)
            
            if response.result.isSuccess {
                
                let jsonResponse = response.value as! NSDictionary
                let responseEntity = Mapper<ResponseEntity>().map(JSONObject: jsonResponse)
                let products = responseEntity?.data

                self.homeProtocol?.onGettingProductsSuccess(products: products!)
            }else{
                self.homeProtocol?.onGettingProductsError(message: "Errorrr")
            }
        }
        
    }
    
    func getProductsByCategory(categoryId : Int){
        var lang = "en";
        if MOLHLanguage.isArabic() {
            lang = "ar"
        }
        Alamofire.request(Constant.BASE_URL + productsUrl + "?q[category_id_eq]=\(categoryId)" + "?locale=" + lang, headers: ApiManager.getHeaders()).responseJSON{ response in
            
            print(response)
            
            if response.result.isSuccess {
                
                let jsonResponse = response.value as! NSDictionary
                let responseEntity = Mapper<ResponseEntity>().map(JSONObject: jsonResponse)
                let products = responseEntity?.data
                
                self.homeProtocol?.onGettingProductsSuccess(products: products!)
            }else{
                self.homeProtocol?.onGettingProductsError(message: "Errorrr")
            }
        }
        
    }
    
    func getOffers(){
        var lang = "en";
        if MOLHLanguage.isArabic() {
            lang = "ar"
        }
        Alamofire.request(Constant.BASE_URL + offersUrl + "?locale=" + lang, headers: ApiManager.getHeaders()).responseJSON{ response in
            
            print(response)
            if response.result.isSuccess {
                
                let jsonResponse = response.result.value as! NSDictionary
                let responseEntity = Mapper<ResponseEntity>().map(JSONObject: jsonResponse)
                let products = responseEntity?.data
                
                self.homeProtocol?.onGettingOffersSuccess(products: products!)
            }else{
                self.homeProtocol?.onGettingOffersError(message: "Errorrr")
            }
        }
        
    }
    
    func getCategories(){
        var lang = "en";
        if MOLHLanguage.isArabic() {
            lang = "ar"
        }
        Alamofire.request(Constant.BASE_URL + categoriesUrl + "?locale=" + lang, headers: ApiManager.getHeaders()).responseJSON{ response in
            
            if response.result.isSuccess {
                let jsonResponse = response.value as! NSDictionary
                let categoryJson = jsonResponse["data"]
                let categories = Mapper<Category>().mapArray(JSONObject: categoryJson)
                
                self.homeProtocol?.onGettingCategoriesSuccess(categories: categories!)
            }else{
                self.homeProtocol?.onGettingCategoriesError(message: "Errorrr")
            }
        }

    }
    
//    func getLastOrder(){
//        
//        Alamofire.request(Constant.BASE_URL + lastOrderUrl, headers: ApiManager.getHeaders()).responseJSON{ response in
//            
//            if response.result.isSuccess {
//                let jsonResponse = response.value as! NSDictionary
//                print("//////////////////")
//                print(jsonResponse)
//                if "\(jsonResponse["status"] ?? "")" == "500" {
//                    self.homeProtocol?.onGettingLastOrderError(message: "Errorrr")
//                } else {
//                    let orderJson = jsonResponse["data"]
//                    
//                    let order = Mapper<Order>().map(JSONObject: orderJson)
//                    
//                    self.homeProtocol?.onGettingLastOrderSuccess(order: order!)
//                   
//                }
//            } else {
//                self.homeProtocol?.onGettingLastOrderError(message: "Errorrr")
//            }
//        }
//        
//    }
    
    func getMeter(){
        
        Alamofire.request(Constant.BASE_URL + meterUrl, headers: ApiManager.getHeaders()).responseJSON{ response in
            
            if response.result.isSuccess {
                let jsonResponse = response.value as! NSDictionary
                let meterJson = jsonResponse["data"]
                let meter = Mapper<Meter>().map(JSONObject: meterJson)
                
                self.homeProtocol?.onGettingMeterSuccess(meter: meter!)
            }else{
                self.homeProtocol?.onGettingMeterError(message: "Errorrr")
            }
        }
        
    }
}
