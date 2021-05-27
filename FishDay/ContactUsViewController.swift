//
//  ContactUsViewController.swift
//  FishDay
//
//  Created by Medhat Mohamed on 4/7/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import UIKit
import MOLH

class ContactUsViewController: UIViewController, CartGetProtocol, LastOrderGetProtocol {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    let notificationButton = SSBadgeButton()
    
    var cartGetModel = CartGetModel()
    var lastOrderGetModel = LastOrderGetModel()
    
    func addCartBarButton() {
        notificationButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        notificationButton.setImage(UIImage(named: "menu_cart")?.withRenderingMode(.alwaysTemplate), for: .normal)
        notificationButton.addTarget(self, action: #selector(self.openCart), for: .touchUpInside)
        notificationButton.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 15)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: notificationButton)
        let order = UserDefUtil.getOrder()
        if order.status == 0 {
            if let count = order.orderItems?.count
            {
                notificationButton.badge = "\(count)"
            }
        } else {
            notificationButton.badge = "0"
        }
    }
    
    @objc func openCart() {
        lastOrderGetModel.getLastOrder()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        addCartBarButton()
        
        title = "Contact us".localized
        if revealViewController() != nil{
            menuButton.target = self.revealViewController()
            if MOLHLanguage.isArabic()
            {
                menuButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            }
            else
            {
                menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            }
            
        }
        
        cartGetModel.cartGetProtocol = self
        cartGetModel.getCart()
        
        lastOrderGetModel.lastOrderGetProtocol = self

    }
    
    func openURaL(url : String) {
        UIApplication.shared.openURL(NSURL(string: url)! as URL)
    }
    
    @IBAction func whatsApp(_ sender: UIButton) {
        openURaL(url: "http://api.whatsapp.com/send?phone=966576359732")
    }
    @IBAction func instagram(_ sender: UIButton) {
        openURaL(url: "https://www.instagram.com/fishday_ksa/")
    }
    @IBAction func twitter(_ sender: UIButton) {
        openURaL(url: "https://twitter.com/fishday_ksa")
    }
    @IBAction func faceBook(_ sender: UIButton) {
        openURaL(url: "https://www.facebook.com/%D9%8A%D9%88%D9%85-%D8%A7%D9%84%D8%B3%D9%85%D9%83-515788785460014")
    }
    @IBAction func snapChat(_ sender: UIButton) {
        openURaL(url: "https://www.snapchat.com/add/fishday_ksa")
    }
    
    func onGettingCartSuccess(order: Order) {
        UserDefUtil.saveOrder(order: order)
        if (order.orderItems!.count ) > 0 {
            notificationButton.badge = "\(order.orderItems?.count ?? 0)"
        }
    }
    
    func onGettingCartError(message: String) {
        print(message)
    }
    
    func onGettingLastOrderSuccess(order: Order?) {
        if order == nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CartNavigation")
            self.revealViewController().frontViewController = vc
        } else {
            if order!.status != 1 && order!.status != 2 && order!.status != 3 {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "CartNavigation")
                self.revealViewController().frontViewController = vc
            } else {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let orderStatusViewController = storyBoard.instantiateViewController(withIdentifier: "OrderStatusViewController") as! OrderStatusViewController
                orderStatusViewController.isFromMenu = false
                navigationController?.pushViewController(orderStatusViewController, animated: true)
            }
        }
    }
    
    func onGettingLastOrderError(message: String) {
        let alert = UIAlertController(title: "FishDay".localized, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK".localized, style: UIAlertAction.Style.default, handler:  { action in
            print("order input empty ..")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}
