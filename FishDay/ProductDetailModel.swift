//
//  ProductDetailModel.swift
//  FishDay
//
//  Created by Water Flower on 9/20/20.
//  Copyright © 2020 Anas Sherif. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import MOLH

class ProductDetailModel: NSObject {

    let productDetailUrl = "products/" // GET
    var productDetailProtocol: ProductDetailProtocol?

    public func getProductDetail(productID: String, lang: String) {
        
        Alamofire.request(Constant.BASE_URL + productDetailUrl + productID + "?locale=" + lang, method: .get, encoding: JSONEncoding.default, headers: ApiManager.getHeaders()).responseJSON{
            response in
            print(response)
            
            if response.result.isSuccess {
                let jsonRes = response.value as! NSDictionary
                
                let status = jsonRes["status"] as! String
                switch status {
                case "success":
                    let productJson = jsonRes["data"]
                    let product = Mapper<Product>().map(JSON: productJson as! [String : Any])
                    self.productDetailProtocol?.onGettingProductDetailSuccess(product: product!)
                    break
                case "fail":
                    let message = jsonRes["message"] as! String
                    self.productDetailProtocol?.onGettingProductDetailError(message: message)
                    break
                default:
                    break
                }
            }else{
                self.productDetailProtocol?.onGettingProductDetailError(message: "Error")
            }
        }
    }
}
