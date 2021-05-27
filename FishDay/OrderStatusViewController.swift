//
//  OrderStatusViewController.swift
//  FishDay
//
//  Created by Medhat Mohamed on 3/24/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import UIKit
import MOLH
import SVProgressHUD
import Alamofire
import ObjectMapper
class OrderStatusViewController: UIViewController, OrderStatusProtocol {
  
    func onGettingLastOrderSuccess(order: Order) {
        UserDefUtil.saveOrder(order: order)
        
          setUiData()
    
    }
    
    func onGettingLastOrderError(message: String) {
        print(message)
    }
    
    
    //------hajor update  --
   var orderStatusModel = OrderStatusModel()
     let lastOrderUrl = "orders/last_incomplete_order"
    
    
    //---
    @IBOutlet weak var orderOnWayImage: UIImageView!
    @IBOutlet weak var orderMovedImage: UIImageView!
    @IBOutlet weak var orderPlacedImage: UIImageView!
    @IBOutlet weak var orderPlacedView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var orderPriceLabel: UILabel!
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var orderMovedView: UIView!
    @IBOutlet weak var orderOnWayView: UIView!
    @IBOutlet weak var orderTimeLabel: UILabel!
    @IBOutlet weak var addressTitle: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var orderNumberTitle: UILabel!
    @IBOutlet weak var orderPlacedLabel: UILabel!
    @IBOutlet weak var orderMovedLabel: UILabel!
    @IBOutlet weak var orderOnWayLabel: UILabel!
    @IBOutlet var paymentMethodLabel: UILabel!
    @IBOutlet var paymentMethodValueLabel: UILabel!
    @IBOutlet var paymentStatusLabel: UILabel!
    @IBOutlet var paymentStatusValueLabel: UILabel!
    
    var order : Order?
    var isFromMenu = true
    
    let notificationButton = SSBadgeButton()
    
    func addCartBarButton() {
        notificationButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        notificationButton.setImage(UIImage(named: "menu_cart")?.withRenderingMode(.alwaysTemplate), for: .normal)
        notificationButton.addTarget(self, action: #selector(self.openCart), for: .touchUpInside)
        notificationButton.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 15)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: notificationButton)
        let order = UserDefUtil.getOrder()
        if let count = order.orderItems?.count
        {
            notificationButton.badge = "\(count)"
          //------------was here braeckpoint ----
            print("was here braeckpoint")
            
        }
    }
    
    @objc func openCart() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CartNavigation")
        //        let navController =  UINavigationController(rootViewController: vc)
        self.revealViewController().frontViewController = vc
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        addCartBarButton()
        orderNumberTitle.text = "OrderNumber".localized
        currencyLabel.text = "SAR".localized
        addressTitle.text = "Address".localized
        orderPlacedLabel.text = "OrderPlaced".localized
        orderMovedLabel.text = "OrderMoved".localized
        orderOnWayLabel.text = "OrderOnWay".localized
        self.paymentMethodLabel.text = "payment_method".localized
        self.paymentStatusLabel.text = "payment_status".localized
     
        orderStatusModel.orderStatusProtocol = self
        
        //-------hajor ---
        orderStatusModel.getLastOrder()
      
        if isFromMenu
        {
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
        }
        else
        {
            
           
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
            
            // add backButton
            }
            print("Back .....")
            
        }
    }
    
    
    
    func setUiData() {
        
        addressLabel.text = UserDefUtil.getOrder().address
        orderNumberLabel.text = "\(UserDefUtil.getOrder().id ?? 0)"
        orderPriceLabel.text = UserDefUtil.getOrder().total
        orderTimeLabel.text = "\(UserDefUtil.getOrder().createdAt?.toSupportDate().dayMonthString ?? "") at \(UserDefUtil.getOrder().createdAt?.toSupportDate().timeString ?? "")"
        orderPlacedView.roundView()
        orderMovedView.roundView()
        orderOnWayView.roundView()
        orderPlacedView.backgroundColor = UIColor.init(hexString: "26ed42")
   
    
        if UserDefUtil.getOrder().status == 1 {
            orderMovedView.backgroundColor = UIColor.init(hexString: "d4d4d4")
            orderOnWayView.backgroundColor = UIColor.init(hexString: "d4d4d4")
        } else if UserDefUtil.getOrder().status == 2 {
            orderMovedView.backgroundColor = UIColor.init(hexString: "26ed42")
            orderOnWayView.backgroundColor = UIColor.init(hexString: "d4d4d4")
        } else if UserDefUtil.getOrder().status == 3 {
            orderMovedView.backgroundColor = UIColor.init(hexString: "26ed42")
            orderOnWayView.backgroundColor = UIColor.init(hexString: "26ed42")
        }
        
        if UserDefUtil.getOrder().payment_method == "mada" { // mada
            self.paymentMethodValueLabel.text = "payment_method_mada".localized
        } else {  // == 1: cash
            self.paymentMethodValueLabel.text = "payment_method_cash".localized
        }

        if UserDefUtil.getOrder().payment_status == "pending" { // pending
            self.paymentStatusValueLabel.text = "payment_status_pending".localized
        } else if UserDefUtil.getOrder().payment_status == "cancelled" { // cancelled
            self.paymentStatusValueLabel.text = "payment_status_cancelled".localized
        } else { // paid
            self.paymentStatusValueLabel.text = "payment_status_paid".localized
        }
        
    }
    
    
    
    
    
   
    
    
    
    
  
    
    
}
