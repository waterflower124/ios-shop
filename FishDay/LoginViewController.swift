//
//  LoginViewController.swift
//  FishDay
//
//  Created by Muhammad Kamal on 2/17/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SVProgressHUD
import DropDown
import OneSignal

class LoginViewController: UIViewController, LoginProtocol {


    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var mobileNumberTitle: UILabel!
    @IBOutlet weak var countryTitle: UILabel!
    @IBOutlet weak var cityTitle: UILabel!
    @IBOutlet weak var fishDayTitle: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var mobileNumberField: EUITextField!
    @IBOutlet weak var goToMarketButton: UIButton!
    @IBOutlet weak var countryTF: UITextField!
    var code : String?
    var mobileNumber : String?
    var loginModel = LoginModel()
    var user = User()
    var citiesArray = [City]()
    var selectedCityId = 0
    
    var universal_link_productId: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginModel.loginProtocol = self
        SVProgressHUD.show()
        loginModel.getCities()
        messageLabel.text = "ConfirmationCodeMessage".localized
        countryTF.text = "KSA".localized
        fishDayTitle.text = "FishDay".localized
        countryTitle.text = "Country".localized
        cityTitle.text = "City".localized
        mobileNumberTitle.text = "MobileNumber".localized
        registerButton.setTitle("Login".localized, for: .normal)
        goToMarketButton.setTitle("GoToMarket".localized, for: .normal)
        
        mobileNumberField.keyboardType = .asciiCapableNumberPad
        mobileNumberField.languageCode = "en"
        if #available(iOS 13, *) {
            mobileNumberField.keyboardType = mobileNumberField.keyboardType
        }
        
    }
    func setFirstCity() {
        if citiesArray.count > 0 {
            self.cityLabel.text = citiesArray[0].name
            selectedCityId = citiesArray[0].id!
        }
    }
    
    @IBAction func chooseCityAction(_ sender: UIButton) {
        let dropDown = DropDown()
        dropDown.anchorView = sender
        dropDown.dataSource = citiesArray.map{$0.name ?? ""}
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.cityLabel.text = item
            self.selectedCityId = self.citiesArray[index].id!
        }
        dropDown.show()
    }
    
    private func login(){
        
        var mobNo = mobileNumberField.text
        if(mobNo?.count != 9) {
            let alert = UIAlertController(title: "FishDay".localized, message: "invalid_phonenumber".localized, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK".localized, style: UIAlertAction.Style.default, handler:  { action in
                print("order input empty ..")
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        if (mobNo?.hasPrefix("0"))!
        {
            mobNo?.removeFirst()
        }
        SVProgressHUD.show()
        user.mobileNumber = "+966" + mobNo!
        user.cityId = selectedCityId
        let userDefaults = UserDefaults()
        let push_token = userDefaults.string(forKey: Constant.PUSH_TOKEN)
        user.device_token = push_token
        loginModel.login(user: user)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Home" {
            let homeViewController = segue.destination as! SWRevealViewController
            homeViewController.title = "Home View"
        }else if (segue.identifier == "ConfirmationScreen") {
            let confirmationController = segue.destination as! ConfirmationViewController
            confirmationController.code = self.code
            confirmationController.register = true
            confirmationController.mobileNumber = self.mobileNumber
            confirmationController.title = "Confirmaion"
            confirmationController.universal_link_productId = self.universal_link_productId
        }
    }
    
    func onGettingCitiesSuccess(cities: [City]) {
        // Handle showing cities
        if SVProgressHUD.isVisible() {
            SVProgressHUD.dismiss()
        }
        citiesArray = cities
        setFirstCity()
        
    }
    func onGettingCitiesError(message: String) {
        if SVProgressHUD.isVisible() {
            SVProgressHUD.dismiss()
        }
        print(message)
    }
    func onLoginSuccess(user: User) {
        if SVProgressHUD.isVisible() {
            SVProgressHUD.dismiss()
        }
        self.code = user.code
        self.mobileNumber = user.mobileNumber
        if user.mobileNumber == nil {
            // guest go to home
            UserDefUtil.saveUser(user: user)
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let mainNavigationController: SWRevealViewController = mainStoryboard.instantiateViewController(withIdentifier: "Main") as! SWRevealViewController
            self.present(mainNavigationController, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "ConfirmationScreen", sender: self)
        }
    }
    
    func onLoginError(message: String) {
        if SVProgressHUD.isVisible() {
            SVProgressHUD.dismiss()
        }
        print(message)
    }
    func onLoginGuestSuccess(user: User) {
        if SVProgressHUD.isVisible() {
            SVProgressHUD.dismiss()
        }
        UserDefUtil.saveUser(user: user)
        UserDefUtil.saveUniversalProductID(productID: self.universal_link_productId!)
//        performSegue(withIdentifier: "Home", sender: self)
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.setHomeAsRoot()
    }
    func onLoginGuestError(message: String) {
        if SVProgressHUD.isVisible() {
            SVProgressHUD.dismiss()
        }
    }
    @IBAction func goToMarket(_ sender: UIButton) {
        self.getOneSignalNotiToken()
        SVProgressHUD.show()
        let userDefaults = UserDefaults()
        let push_token = userDefaults.string(forKey: Constant.PUSH_TOKEN)
        
        if push_token == nil || push_token == "" {
            user.device_token = ""
        } else {
            user.device_token = push_token
        }
        loginModel.loginGuest(user: user)
    }
    
    @IBAction func login(_ sender: Any) {
        login()
    }
    
    func getOneSignalNotiToken() {
        let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()

        let hasPrompted = status.permissionStatus.hasPrompted
        print("hasPrompted = \(hasPrompted)")
        let userStatus = status.permissionStatus.status
        print("userStatus = \(userStatus)")

        
        let userID = status.subscriptionStatus.userId
        print("userID = \(userID ?? "")")
        let userDefaults = UserDefaults()
        userDefaults.set(userID, forKey: Constant.PUSH_TOKEN)
    }
    
}
