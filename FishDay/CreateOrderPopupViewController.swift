//
//  CreateOrderPopupViewController.swift
//  FishDay
//
//  Created by Medhat Mohamed on 3/24/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import UIKit
import DropDown
import SVProgressHUD
import AppsFlyerLib

class CreateOrderPopupViewController: UIViewController, CreateOrderItemProtocol {
    
    @IBOutlet weak var methodOfSlicingTitle: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var typeOfQuantityTitle: UILabel!
    @IBOutlet weak var typeOfQuantityLabel: UILabel!
    @IBOutlet weak var methodOfSlicingLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var quatityView: UIView!
    @IBOutlet weak var slicingView: UIView!
    @IBOutlet weak var slidingViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var methodofSlicingTitleLebelHeightConstraint: NSLayoutConstraint!
    
    var quantity: Int?
    var order: Order?
    var product: Product?
    var orderItem = OrderItem()
    var methodOfSlicing = 0
    var delegate : HomeProtocol?
    
    var createOrderItemModel = CreateOrderItemModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        methodOfSlicingTitle.text = "MethodOfSlicing".localized
//        typeOfQuantityTitle.text = "TypeOfQuantity".localized
//        cancelButton.setTitle("Cancel".localized, for: .normal)
//        addToCartButton.setTitle("AddToCart".localized, for: .normal)
//        
//        createOrderItemModel.createOrderItemProtocol = self
//        self.order = UserDefUtil.getOrder()
//        if self.product?.quantity_type == "piece"  {
//            self.typeOfQuantityLabel.text = "Per Piece".localized
//            self.methodOfSlicingTitle.isHidden = true
//            self.methodofSlicingTitleLebelHeightConstraint.constant = 0
//            self.slicingView.isHidden = true
//            self.slidingViewHeightConstraint.constant = 0
//            
//        } else if self.product?.quantity_type == "kilo" {
//            self.typeOfQuantityLabel.text = "Per Kilo".localized
//            self.methodOfSlicingTitle.isHidden = false
//            self.methodofSlicingTitleLebelHeightConstraint.constant = 18
//            self.slicingView.isHidden = false
//            self.slidingViewHeightConstraint.constant = 40
//        } else { // for all
//            self.typeOfQuantityLabel.text = "Per Kilo".localized
//            self.methodOfSlicingTitle.isHidden = false
//            self.methodofSlicingTitleLebelHeightConstraint.constant = 18
//            self.slicingView.isHidden = false
//            self.slidingViewHeightConstraint.constant = 40
//            
//        }
//        self.methodOfSlicingLabel.text = "With cleaning".localized
        
    }
    @IBAction func increaseAction(_ sender: UIButton) {
        quantityLabel.text = "\(Int(quantityLabel.text!)! + 1)"
    }
    
    @IBAction func decreaseAction(_ sender: UIButton) {
        if quantityLabel.text != "1"
        {
            quantityLabel.text = "\(Int(quantityLabel.text!)! - 1)"
        }
    }
    
    @IBAction func addToCartAction(_ sender: UIButton) {
        SVProgressHUD.show()

        self.orderItem.orderId = order?.id
        self.orderItem.productId = self.product?.id
        self.orderItem.product = self.product
        self.orderItem.quantity = Int(self.quantityLabel.text!)
        if self.typeOfQuantityLabel.text == "Per Kilo".localized {
            self.orderItem.quantityType = 0
        } else {
            self.orderItem.quantityType = 1
        }
        self.orderItem.cuttingWay = self.methodOfSlicing
        
        self.createOrderItemModel.createOrderItem(orderItem: orderItem)
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func typeOfQuantityAction(_ sender: UIButton) {
        let dropDown = DropDown()
        dropDown.anchorView = sender
        if self.product?.quantity_type == "kilo" {
            dropDown.dataSource = ["Per Kilo".localized]
        } else if self.product?.quantity_type == "piece" {
            dropDown.dataSource = ["Per Piece".localized]
        } else { // for all
            dropDown.dataSource = ["Per Kilo".localized, "Per Piece".localized]
        }
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.typeOfQuantityLabel.text = item
        }
        dropDown.show()
    }
    
    @IBAction func methodOfSlicingAction(_ sender: UIButton) {
        let dropDown = DropDown()
        dropDown.anchorView = sender
        dropDown.dataSource = ["With cleaning".localized, "Without cleaning".localized, "For grilling".localized]
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.methodOfSlicingLabel.text = item
            self.methodOfSlicing = index
        }
        dropDown.show()
    }
    
    func onCreatingOrderItemSuccess(order: Order) {
        if SVProgressHUD.isVisible() {
            SVProgressHUD.dismiss()
        }
        
        /// AppsFly
        var product_price: Float = 0
        if self.orderItem.product?.quantity_type == "piece" {
            product_price = Float((self.orderItem.product?.piecePrice)!)!
        } else if self.orderItem.product?.quantity_type == "kilo" {
            product_price = Float((self.orderItem.product?.kiloPrice)!)!
        } else { // for all
            if Float((self.orderItem.product?.kiloPrice)! as String) != 0 && Float((self.orderItem.product?.kiloPrice)! as String) != nil {
                product_price = Float((self.orderItem.product?.piecePrice)!)!
            } else if Float((self.orderItem.product?.piecePrice)! as String) != 0 && Float((self.orderItem.product?.piecePrice)! as String) != nil {
                product_price = Float((self.orderItem.product?.kiloPrice)!)!
            }
        }
        AppsFlyerTracker.shared().trackEvent(AFEventAddToCart, withValues: [
            AFEventParamPrice: product_price,
            AFEventParamContentId: String((self.orderItem.product?.id)! as Int),
            AFEventParamContentType: (self.orderItem.product?.name!)! as String,
            AFEventParamCurrency: "SAR",
            AFEventParamQuantity: self.orderItem.quantity!
        ]);

        // show cart
        self.dismiss(animated: true, completion: nil)
        self.delegate?.openCart()
        
//        if order.status != 0 {
//            let alert = UIAlertController(title: "FishDay".localized, message: "orderFinish".localized, preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: "OK".localized, style: UIAlertAction.Style.default, handler:  { action in
//
//                self.dismiss(animated: true, completion: nil)
//                print("already processing order is exist ... ...")
//            }))
//            self.present(alert, animated: true, completion: nil)
//        } else {
//            self.dismiss(animated: true, completion: nil)
//            self.delegate?.openCart()
//        }
        
    }
    
    func onCreatingOrderItemError(message: String) {
        if SVProgressHUD.isVisible() {
            SVProgressHUD.dismiss()
        }
        showAlert(withMessage: message)
        
    }
    
    func showAlert(withMessage message: String,andTitle title: String? = nil,shouldShowCancelButton : Bool? = false,withOkAction acceptAction: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {[unowned self] action in
            if acceptAction != nil {
                acceptAction!()
            }
            self.dismiss(animated: true, completion: nil)
        }))
        
        if shouldShowCancelButton! {
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        }
        present(alert, animated: true, completion: nil)
    }
    
}
