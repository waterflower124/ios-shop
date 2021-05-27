//
//  CompleteOrderViewController.swift
//  FishDay
//
//  Created by Medhat Mohamed on 3/24/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import UIKit
import GooglePlacePicker
import GoogleMaps
import GooglePlaces
import PlacesPicker
import PassKit
import MOLH


class CompleteOrderViewController: UIViewController, CompleteOrderProtocol, OrderStatusProtocol, CLLocationManagerDelegate,GMSMapViewDelegate, PlacesPickerDelegate {
    
    
    @IBOutlet weak var nameTextField: EUITextField!
    @IBOutlet weak var getCurrentAddressLabel: UIButton!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var completeOrderButton: UIButton!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var deliveryLabel: UILabel!
    @IBOutlet weak var provideLabel: UILabel!
    @IBOutlet weak var notesTextView: EUITextView!
    @IBOutlet var visaPaymantButton: UIButton!
    @IBOutlet var cashDeliveryButton: UIButton!
    
    @IBOutlet weak var mobileValidaiationLabel: UILabel!
    @IBOutlet var paymentMethodLabel: UILabel!
    @IBOutlet var madaLabel: UILabel!
    @IBOutlet var cashLabel: UILabel!
    
    
    
    var completeOrderModel = CompleteOrderModel()
    var orderStatusModel = OrderStatusModel()
    var userLocation: GMSPlace?
    
    var location :CLLocation?
    var locationManager: CLLocationManager!
    var latitude: Double = 0
    var longitude: Double = 0
    var KEY:Int = 1000
    var first_load: Bool = true
    var payment_visa = 1
    var payment_failed = false // true when redirected from failed payment

    var googleMapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if MOLHLanguage.isArabic() {
            nameTextField.languageCode = "ar"
            notesTextView.languageCode = "ar"
        } else {
            nameTextField.languageCode = "en"
            notesTextView.languageCode = "en"
        }
        
        if #available(iOS 13, *) {
            nameTextField.keyboardType = nameTextField.keyboardType
            notesTextView.keyboardType = notesTextView.keyboardType
        }
        
        mobileTextField.keyboardType = .asciiCapableNumberPad
        
        self.paymentMethodLabel.text = "payment_method".localized
        self.madaLabel.text = "payment_mada".localized
        self.cashLabel.text = "payment_cash".localized
        mobileValidaiationLabel.text = "MobileValidiation".localized
        
        self.locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()

        //-------
        
        PlacePicker.configure(googleMapsAPIKey: "AIzaSyBOSF44W1Z42oyLc0yq5Z_cRA7HkBL2XnY", placesAPIKey: "AIzaSyBOSF44W1Z42oyLc0yq5Z_cRA7HkBL2XnY")
        
//        selectLocation()
        
        
        self.completeOrderModel.completeOrderProtocol = self
        if let mobilenumber = UserDefUtil.getUser().mobileNumber {
            let number = mobilenumber.replacingOccurrences(of: "+966", with: "")
            mobileTextField.text = number
        }
        
        notesTextView.text = "Notes".localized
        notesTextView.textColor = UIColor.lightGray
        
        orderStatusModel.orderStatusProtocol = self
  
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        self.latitude = locValue.latitude
        self.longitude = locValue.longitude
        if(first_load) {
            first_load = false
            selectLocation()
        }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
//        if latitude != 24.711823 {
//            if KEY == 1000 {
//                selectLocation()
//                KEY = 2000
//            } else{
//                print(" display map")
//
//            }
//        } else{
//           //  check = 0
//            print("non display map")
//        }
    }
    
    
    
    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError){
        
        print("An error occurred while tracking location changes : \(error.description)")
    }
    
    
    @IBAction func getCurrentAddressAction(_ sender: UIButton) {
        selectLocation()
    }
    
    @IBAction func visaPaymentButtonAction(_ sender: Any) {
        self.payment_visa = 1
        self.visaPaymantButton.setBackgroundImage(UIImage(named: "radio_check"), for: .normal)
        self.cashDeliveryButton.setBackgroundImage(UIImage(named: "radio_uncheck"), for: .normal)
    }

    @IBAction func deliveryButtonAction(_ sender: Any) {
        self.payment_visa = 0
        self.visaPaymantButton.setBackgroundImage(UIImage(named: "radio_uncheck"), for: .normal)
        self.cashDeliveryButton.setBackgroundImage(UIImage(named: "radio_check"), for: .normal)
    }
    
    
    @IBAction func completeOrderAction(_ sender: UIButton) {
        
        if nameTextField.text == "" || mobileTextField.text == "" || addressTextField.text == "" {
            let alert = UIAlertController(title: "FishDay".localized, message: "orderInputEmpty".localized, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK".localized, style: UIAlertAction.Style.default, handler:  { action in
                print("order input empty ..")
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if mobileTextField.text?.count != 9 {
            let alert = UIAlertController(title: "FishDay".localized, message: "invalid_phonenumber".localized, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK".localized, style: UIAlertAction.Style.default, handler:  { action in
                print("order input empty ..")
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let order = UserDefUtil.getOrder()
        order.userFullName = nameTextField.text
        order.userPhoneNumber = "+966" + mobileTextField.text!
        order.address = addressTextField.text
        order.address_lat = userLocation?.coordinate.latitude
        order.address_long = userLocation?.coordinate.longitude
        order.notes = notesTextView.text
        if self.payment_visa == 1 {
            order.payment_method = "mada"
        } else {
            order.payment_method = "cash"
        }
        order.verification_code = ""
        UserDefUtil.saveOrder(order: order)

        let alert = UIAlertController(title: "FishDay".localized, message: "deliveryAlartMsg".localized, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK".localized, style: UIAlertAction.Style.default, handler:  { action in
            self.completeOrderModel.completeOrder(orderId: UserDefUtil.getOrder().id!, order: order)
            print("Complate Action BTN ..")
        }))
        self.present(alert, animated: true, completion: nil)
        
//        apple_pay(order: order)

    }
    
    func apple_pay(order: Order) {
        var paymentItems = [PKPaymentSummaryItem]()
        
        for index in 0 ..< order.orderItems!.count {
            paymentItems.append(PKPaymentSummaryItem.init(label: order.orderItems![index].product!.name!, amount: NSDecimalNumber(string: order.orderItems![index].totalPrice)))
        }
        
        let paymentNetworks = [PKPaymentNetwork.amex, .discover, .masterCard, .visa]
        
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks) {
            let request = PKPaymentRequest()
            request.currencyCode = "SAR" // 1
            request.countryCode = "SA" // 2
            request.merchantIdentifier = "merchant.com.angles.FishDay" // 3
            request.merchantCapabilities = PKMerchantCapability.capability3DS // 4
            request.supportedNetworks = paymentNetworks // 5
            
            request.paymentSummaryItems = paymentItems // 6
            
            guard let paymentVC = PKPaymentAuthorizationViewController(paymentRequest: request) else {
                print("Unable to present Apple Pay authorization.")
//                displayDefaultAlert(title: "Error", message: "Unable to present Apple Pay authorization.")
                return
            }
            paymentVC.delegate = self
            self.present(paymentVC, animated: true, completion: nil)
            
        } else {
            print("Unable to make Apple Pay transaction.")
//            displayDefaultAlert(title: "Error", message: "Unable to make Apple Pay transaction.")
        }
    }
    
    func goToOrderStatus() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let orderStatusViewController = storyBoard.instantiateViewController(withIdentifier: "OrderStatusViewController") as! OrderStatusViewController
        orderStatusViewController.isFromMenu = false
        navigationController?.pushViewController(orderStatusViewController, animated: true)
    }

    
    func selectLocation() {

        view.endEditing(true)
        
        let loccoord2d = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        let filter = GMSAutocompleteFilter()
        filter.type = .geocode
        
        let fields: GMSPlaceField = GMSPlaceField(rawValue:UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.placeID.rawValue) |
            UInt(GMSPlaceField.coordinate.rawValue) |
            GMSPlaceField.addressComponents.rawValue |
            GMSPlaceField.formattedAddress.rawValue)!
        
        
        let config = PlacePickerConfig(listRenderer: DefaultPlacesListRenderer(), placeFields: fields, placesFilter: filter, pickerRenderer: DefaultPickerRenderer(), initialCoordinate: loccoord2d, initialZoom: 18)

        
        let placePicker = PlacePicker.placePickerController(config: config)
        
        placePicker.delegate = self
        
        let navigationController = UINavigationController(rootViewController: placePicker)
        self.show(navigationController, sender: nil)
      
    }
    
    func placePickerController(controller: PlacePickerController, didSelectPlace place: GMSPlace) {
//        print("\(place.coordinate.latitude)  +  \(place.coordinate.longitude)")
        if let text = place.formattedAddress {
            addressTextField.text = text
            userLocation = place
        } else{
            addressTextField.text = "\(place.coordinate.latitude), \(place.coordinate.longitude)"
        }
        controller.navigationController?.dismiss(animated: true, completion: nil)
    }

    func placePickerControllerDidCancel(controller: PlacePickerController) {
        print("Place selection cancelled")
        controller.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    func onCompleteOrderSuccess(order: Order) {
    
//        let i = 0
//        while i < orderItems.count {
//            print(orderItems[i].id as Any)
//           // i = i + 1
//        }
//       // updateOrderTotalPriceLabels(orderItem: orderItem)
//        //----
        
        if order.target_url == "" || order.target_url == nil {
            if self.payment_visa == 1 {
                let alert = UIAlertController(title: "FishDay".localized, message: "error_message".localized, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK".localized, style: UIAlertAction.Style.default, handler:  { action in
                    print("order input empty ..")
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                goToOrderStatus()
            }
        } else {
            let url = URL(string: order.target_url!)
            
            if UIApplication.shared.canOpenURL(url!) {
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            }
        }
    }
    
    func onCompleteOrderError(message: String) {
        let alert = UIAlertController(title: "FishDay".localized, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK".localized, style: UIAlertAction.Style.default, handler:  { action in
            
            print("Complate Action BTN ..")
        }))
        self.present(alert, animated: true, completion: nil)
        
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
            
            goToOrderStatus()
        } else {
            let alert = UIAlertController(title: "FishDay".localized, message: "completeorder_fail".localized, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK".localized, style: UIAlertAction.Style.default, handler:  { action in
                
                print("Complate Action BTN ..")
            }))
            self.present(alert, animated: true, completion: nil)
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let completeorderViewController = storyBoard.instantiateViewController(withIdentifier: "CompleteOrderViewController") as! CompleteOrderViewController
            navigationController?.pushViewController(completeorderViewController, animated: true)
        }
    }
    
    func onGettingLastOrderError(message: String) {
        let alert = UIAlertController(title: "FishDay".localized, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK".localized, style: UIAlertAction.Style.default, handler:  { action in
            print("order input empty ..")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func goToConfirmation() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let confirmationViewController = storyBoard.instantiateViewController(withIdentifier: "ConfirmationViewController") as! ConfirmationViewController
        confirmationViewController.mobileNumber = "966" + mobileTextField.text!
        confirmationViewController.payment_visa = self.payment_visa
        navigationController?.pushViewController(confirmationViewController, animated: true)
    }
}


extension CompleteOrderViewController: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Notes".localized
            textView.textColor = UIColor.lightGray
        }
    }
}

extension CompleteOrderViewController: PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        
        print("payment autho finish delegate ")
        dismiss(animated: true, completion: nil)
        
        
    }
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        print("payment autho payment delegate ")
        dismiss(animated: true, completion: nil)
    }
    
}

