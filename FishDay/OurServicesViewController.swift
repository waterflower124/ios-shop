//
//  OurServicesViewController.swift
//  FishDay
//
//  Created by Medhat Mohamed on 6/11/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import UIKit
import SVProgressHUD
import MOLH

class OurServicesViewController: UIViewController, OurServicesProtocol, CartGetProtocol, LastOrderGetProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var myOrdersModel = OurServicesModel()
    var orders = [Product]()
    
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
        title = "Services".localized
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        myOrdersModel.myOrdersProtocol = self
        cartGetModel.cartGetProtocol = self
        
        lastOrderGetModel.lastOrderGetProtocol = self
        
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
        getMyOrders()
        cartGetModel.getCart()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getMyOrders(){
        SVProgressHUD.show()
        self.myOrdersModel.getMyOrders()
    }
    
    func onGettingOurServicesError(message: String) {
        print(message)
    }
    
    func onGettingOurServicesSuccess(orders: [Product]) {
        SVProgressHUD.dismiss()
        self.orders = orders
        self.tableView.reloadData()
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
    
    func openWhatsApp() {
        UIApplication.shared.openURL(NSURL(string: "http://api.whatsapp.com/send?phone=0558308096")! as URL)
    }
}
extension OurServicesViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OurServicesTableViewCell", for: indexPath)
            as! OurServicesTableViewCell
        
        let order = orders[indexPath.row]
        cell.order = order
        cell.selectionStyle = .none
        cell.orderButton.tag = indexPath.row
        cell.orderButton.addTarget(self, action: #selector(self.openWhatsAppAction(sender:)), for: .touchUpInside)
        cell.orderButton.setTitle("Contact us".localized, for: .normal)

        return cell
    }
    
    @objc func openWhatsAppAction(sender: UIButton){
        openWhatsApp()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print("Clickkkk")
    }
}
