//
//  MenuViewController.swift
//  FishDay
//
//  Created by Anas Sherif on 2/21/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import UIKit
import MOLH
import Alamofire
import ObjectMapper

class MenuViewController: UIViewController, LastOrderGetProtocol {
   

    @IBOutlet weak var tableView: UITableView!
    
    var menuList = [Menu]()
    
    var lastOrderGetModel = LastOrderGetModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menuList.append(Menu(name: "Home".localized, imageName: "home-1"))
        menuList.append(Menu(name: "My Orders".localized, imageName: "menu_fish"))
        menuList.append(Menu(name: "Cart".localized, imageName: "cart"))
        menuList.append(Menu(name: "Services".localized, imageName: "cart"))
        menuList.append(Menu(name: "About".localized, imageName: "info"))
        menuList.append(Menu(name: "Contact us".localized, imageName: "phone"))
        menuList.append(Menu(name: "Language".localized, imageName: "phone"))
        menuList.append(Menu(name: "Logout".localized, imageName: "logout"))
        
        tableView.dataSource = self
        tableView.delegate = self
        
        lastOrderGetModel.lastOrderGetProtocol = self
        
//        tableView.estimatedRowHeight = tableView.rowHeight // 376
//        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension MenuViewController: UITableViewDataSource, UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Menu", for: indexPath)
         as! MenuTableViewCell
        let menu = menuList[indexPath.row]
        cell.menu = menu
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print("Clickkkk")
        var segueIdentifier: String
        switch indexPath.row {
        case 0:
            segueIdentifier = "HomeSegue"
            performSegue(withIdentifier: segueIdentifier, sender: self)
        case 1:
            segueIdentifier = "MyOrdersSegue"
            performSegue(withIdentifier: segueIdentifier, sender: self)
        case 2:
            lastOrderGetModel.getLastOrder()
        case 3:
            // services
            segueIdentifier = "OurServicesSegue"
            performSegue(withIdentifier: segueIdentifier, sender: self)

            break
        case 4:
            segueIdentifier = "AboutSegue"
            performSegue(withIdentifier: segueIdentifier, sender: self)
        case 5:
            segueIdentifier = "ContactUsSegue"
            performSegue(withIdentifier: segueIdentifier, sender: self)
        case 6:
            
            
            // Change Language
            MOLH.setLanguageTo(MOLHLanguage.currentAppleLanguage() == "en" ? "ar" : "en")
            MOLH.reset()
            let delegate = UIApplication.shared.delegate as! AppDelegate
     
            delegate.setHomeAsRoot()
        case 7:
            //            segueIdentifier = "HomeSegue"
            // Logout go to login
            self.logout()
            UserDefUtil.clearAllData()
            let delegate = UIApplication.shared.delegate as! AppDelegate
            delegate.setLoginAsRoot()
          

        default:
            segueIdentifier = "HomeSegue"
            performSegue(withIdentifier: segueIdentifier, sender: self)
        }
    }
    
    func onGettingLastOrderSuccess(order: Order?) {
        
        var segueIdentifier: String
        if order != nil {
            segueIdentifier = "StatusSegue"
        } else {
            segueIdentifier = "CartSegue"
        }
        performSegue(withIdentifier: segueIdentifier, sender: self)
    }
    
    func onGettingLastOrderError(message: String) {
        print(message)
    }
    
    func logout() {
        print(ApiManager.getHeaders())
        Alamofire.request(Constant.BASE_URL + "users/logout", method: .post, encoding: JSONEncoding.default, headers: ApiManager.getHeaders()).responseJSON  {
                response in
                print("logout response \(response)")
                
                if response.result.isSuccess {
                                        
                } else {
                    print("logout error ")
                }
        }
    }
}
