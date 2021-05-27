//
//  FullScreenImageViewController.swift
//  FishDay
//
//  Created by Medhat Mohamed on 4/12/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import UIKit

class FullScreenImageViewController: UIViewController {

    @IBOutlet weak var fullScreenImage: UIImageView!
    
    var imageUrl : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImage()
    }
    func setImage() {
        if imageUrl != nil {
            let downloadURL = URL(string: imageUrl!)
            if downloadURL != nil {
                self.fullScreenImage.af_setImage(withURL: downloadURL!)
            } else {
                self.fullScreenImage.image = #imageLiteral(resourceName: "fish")
            }
        }
    }
}
