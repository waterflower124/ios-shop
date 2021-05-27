//
//  ConfirmationViewController.swift
//  FishDay
//
//  Created by Anas Sherif on 3/12/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SVProgressHUD
import MOLH

class ConfirmationViewController: UIViewController, ConfirmationProtocol, OrderStatusProtocol {

    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var verificationCodeField: UITextField!
    
    @IBOutlet weak var confirmAccountButton: UIButton!
    @IBOutlet weak var confirmMessage: UILabel!
    @IBOutlet weak var confirmCodeTitle: UILabel!
    @IBOutlet weak var confirmAccountTitle: UILabel!
    @IBOutlet weak var fourthTF: UITextField!
    @IBOutlet weak var thirdTF: UITextField!
    @IBOutlet weak var secondTF: UITextField!
    @IBOutlet weak var firstTF: UITextField!

    
    var confirmationModel = ConfirmationModel()
    var orderStatusModel = OrderStatusModel()
    var user = User()
    var code : String?
    var mobileNumber : String?
    var order = Order()
    var register = false // when register true, when order confirm false
    var payment_visa = 1
    
    var universal_link_productId: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.text = "ConfirmationCodeSentMessage".localized
        confirmCodeTitle.text = "ConfirmationCode".localized
        confirmAccountTitle.text = "ConfirmAccount".localized
        confirmAccountButton.setTitle("ConfirmAccount".localized, for: .normal)
        
        self.confirmationModel.confirmationProtocol = self
        orderStatusModel.orderStatusProtocol = self
//        verificationCodeField.text = code
//        messageLabel.text = "Code has been sent\nplease write it\nhere"
        if !register {
            order = UserDefUtil.getOrder()
        }
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Main" {
            let mainNavigationController = segue.destination as! SWRevealViewController
            
        }
    }
    
    
    private func verify() {
        
        var verify_code = ""
        if MOLHLanguage.currentAppleLanguage() == "en" {
            verify_code = "\(firstTF.text ?? "")\(secondTF.text ?? "")\(thirdTF.text ?? "")\(fourthTF.text ?? "")"
        } else {
            verify_code = "\(fourthTF.text ?? "")\(thirdTF.text ?? "")\(secondTF.text ?? "")\(firstTF.text ?? "")"
        }
        if verify_code.count < 4 {
            let alert = UIAlertController(title: "FishDay".localized, message: "verificationCodeEmpty".localized, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK".localized, style: UIAlertAction.Style.default, handler:  { action in
                print("order input empty ..")
            }))
            self.present(alert, animated: true, completion: nil)
            return;
        }
        SVProgressHUD.show()
        order.verification_code = verify_code
        user.code = verify_code
        user.mobileNumber = self.mobileNumber
        confirmationModel.verify(order: order, user: user, register: self.register)
    }
    
    func onConfirmationSuccess(user: User) {
        if SVProgressHUD.isVisible() {
            SVProgressHUD.dismiss()
        }

        UserDefUtil.saveUser(user: user)
        UserDefUtil.saveUniversalProductID(productID: self.universal_link_productId!)
//        performSegue(withIdentifier: "Main", sender: self)
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.setHomeAsRoot()
    }
    
    func onConfirmationError(message: String) {
        if SVProgressHUD.isVisible() {
            SVProgressHUD.dismiss()
        }
        let alert = UIAlertController(title: "FishDay".localized, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK".localized, style: UIAlertAction.Style.default, handler:  { action in
            print("confirmation error ...")
        }))
        self.present(alert, animated: true, completion: nil)
        print(message)
    }
    
    func onCompleteOrderSuccess(order: Order) {
        if SVProgressHUD.isVisible() {
            SVProgressHUD.dismiss()
        }
        UserDefUtil.saveOrder(order: order)
        if self.payment_visa == 1 {
            let url = URL(string: order.target_url!)
            if UIApplication.shared.canOpenURL(url!) {
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            }
        } else {
            goToOrderStatus()
        }
    }
    
    func onCompleteOrderError(message: String) {
        if SVProgressHUD.isVisible() {
            SVProgressHUD.dismiss()
        }
        let alert = UIAlertController(title: "FishDay".localized, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK".localized, style: UIAlertAction.Style.default, handler:  { action in
           print("confirmation error ...")
        }))
        self.present(alert, animated: true, completion: nil)
        print(message)
    }
    
    func goToOrderStatus() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let orderStatusViewController = storyBoard.instantiateViewController(withIdentifier: "OrderStatusViewController") as! OrderStatusViewController
        orderStatusViewController.isFromMenu = false
        navigationController?.pushViewController(orderStatusViewController, animated: true)
    }
    
    
    @IBAction func confirmAccount(_ sender: Any) {
        verify()
    }
    
    public func callbackPayment() {
       
        orderStatusModel.getLastOrder()
    }
    
    func onGettingLastOrderSuccess(order: Order) {
        
        UserDefUtil.saveOrder(order: order)
        if order.status != 0 {
            let alert = UIAlertController(title: "FishDay".localized, message: "completeorder_success".localized, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK".localized, style: UIAlertAction.Style.default, handler:  { action in
                
                print("Complate Action BTN ..")
            }))
            self.present(alert, animated: true, completion: nil)
            
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let orderStatusViewController = storyBoard.instantiateViewController(withIdentifier: "OrderStatusViewController") as! OrderStatusViewController
            orderStatusViewController.isFromMenu = false
            navigationController?.pushViewController(orderStatusViewController, animated: true)
        } else {
            let alert = UIAlertController(title: "FishDay".localized, message: "completeorder_fail".localized, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK".localized, style: UIAlertAction.Style.default, handler:  { action in
                
                print("Complate Action BTN ..")
            }))
            self.present(alert, animated: true, completion: nil)
            
            self.navigationController?.popViewController(animated: true)
            
//            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//            let completeorderViewController = storyBoard.instantiateViewController(withIdentifier: "CompleteOrderViewController") as! CompleteOrderViewController
//            completeorderViewController.payment_failed = true
//            navigationController?.pushViewController(completeorderViewController, animated: true)
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




extension ConfirmationViewController : UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("----------------\(MOLHLanguage.currentAppleLanguage())")
        if string.count <= 1 {
            if MOLHLanguage.currentAppleLanguage() == "en" {
                if textField == firstTF {
                    firstTF.text = string
                    secondTF.becomeFirstResponder()
                } else if textField == secondTF {
                    secondTF.text = string
                    thirdTF.becomeFirstResponder()
                } else if textField == thirdTF {
                    thirdTF.text = string
                    fourthTF.becomeFirstResponder()
                } else {
                    fourthTF.text = string
                    fourthTF.resignFirstResponder()
                }
            } else {
                if textField == fourthTF {
                    fourthTF.text = string
                    thirdTF.becomeFirstResponder()
                    print("4444444444444444")
                } else if textField == thirdTF {
                    thirdTF.text = string
                    secondTF.becomeFirstResponder()
                    print("33333333333333333")
                } else if textField == secondTF {
                    secondTF.text = string
                    firstTF.becomeFirstResponder()
                    print("22222222222222222222")
                } else {
                    firstTF.text = string
                    firstTF.resignFirstResponder()
                    print("11111111111111111111")
                }
            }
            return false
        }
        return false
    }
}
