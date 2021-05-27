//
//  UIViewExtension.swift
//  FishDay
//
//  Created by Medhat Mohamed on 3/29/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import UIKit

extension UIView {
    func roundView() {
        self.layer.cornerRadius = self.frame.size.width/2
        self.clipsToBounds = true
    }
}


