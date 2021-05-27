//
//  ApiManager.swift
//  FishDay
//
//  Created by Anas Sherif on 3/6/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import UIKit
import Alamofire
class ApiManager: NSObject {

    static let headers :HTTPHeaders = ["ApiKey": "key=1d7801c576b33db841d59216d8cf91d4"]
    
    class func getHeaders() -> HTTPHeaders{
        let httpHeaders = ["ApiKey": "key=1d7801c576b33db841d59216d8cf91d4", "Authorization": UserDefUtil.getUser().authToken!]
        print("auth key:::\(UserDefUtil.getUser().authToken!)")
        return httpHeaders
    }
    
    public class func loadImage(imageView: UIImageView, imageUrl: String){
        if (imageUrl != nil) {
            let downloadURL = URL(string: imageUrl)
            if downloadURL != nil {
                imageView.af_setImage(withURL: downloadURL!)
            } else {
                imageView.image = #imageLiteral(resourceName: "fish")
            }
        }
    }
    
}
