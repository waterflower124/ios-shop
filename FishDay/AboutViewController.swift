//
//  AboutViewController.swift
//  FishDay
//
//  Created by Medhat Mohamed on 6/30/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import UIKit
import MOLH

class AboutViewController: UIViewController, CartGetProtocol, LastOrderGetProtocol {
    
    @IBOutlet weak var about: UITextView!
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
            if let count = order.orderItems?.count {
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
        title = "About".localized
        about.text = "AboutDesc".localized
        if revealViewController() != nil{
            menuButton.target = self.revealViewController()
            if MOLHLanguage.isArabic() {
                menuButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            } else {
                menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            }
            
        }
        
        cartGetModel.cartGetProtocol = self
        cartGetModel.getCart()
        
        lastOrderGetModel.lastOrderGetProtocol = self
        
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
