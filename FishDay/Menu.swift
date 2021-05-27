//
//  Menu.swift
//  FishDay
//
//  Created by Anas Sherif on 2/20/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import UIKit

class Menu
{
    var name: String
    var icon: UIImage
    
    init(name: String, imageName: String) {
        
        self.name = name
        if let icon = UIImage(named: imageName){
            self.icon = icon
        }
            else{
            self.icon = UIImage(named: "default")!
            }
        }
}
