//
//  CartViewController.swift
//  FishDay
//
//  Created by Muhammad Kamal on 2/17/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import UIKit
import SVProgressHUD
import MOLH

class CartViewController: UIViewController, CartProtocol, CartGetProtocol{


    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var cartBarButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var currencyyy: UILabel!
    @IBOutlet weak var currencyy: UILabel!
    @IBOutlet weak var deliveryLabel: UILabel!
    @IBOutlet weak var subTotal: UILabel!
    @IBOutlet weak var deliveryTitle: UILabel!
    @IBOutlet weak var subTotalTitle: UILabel!
    @IBOutlet weak var currencyTitle: UILabel!
    @IBOutlet weak var orderNowButton: UIButton!
    @IBOutlet weak var totalCostTitle: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    var cartModel = CartModel()
    var cartGetModel = CartGetModel()
    var order = Order()
    var orderTotalPrice = Double()
    var orderItems = [OrderItem]()
    
    let notificationButton = SSBadgeButton()
    
    var order_now_action: Bool = false // true when click Order Now button action, false when click increase or decrease button
    
    func addCartBarButton() {
        notificationButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        notificationButton.setImage(UIImage(named: "menu_cart")?.withRenderingMode(.alwaysTemplate), for: .normal)
        notificationButton.addTarget(self, action: #selector(self.openCart), for: .touchUpInside)
        notificationButton.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 15)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: notificationButton)
        let order = UserDefUtil.getOrder()
        if let count = order.orderItems?.count
        {
            if count > 0 {
                notificationButton.isHidden = false
                notificationButton.badge = "\(count)"
            }else{
                notificationButton.isHidden = true
                notificationButton.badge = "\(count)"
            }
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
        title = "Cart".localized
        totalCostTitle.text = "TotalCost".localized
        currencyTitle.text  = "SAR".localized
        currencyy.text  = "SAR".localized
        currencyyy.text  = "SAR".localized
        deliveryTitle.text = "Tax".localized
        subTotalTitle.text = "SubTotal".localized
        orderNowButton.setTitle("OrderNow".localized, for: .normal)
        cartModel.cartProtocol = self
        cartGetModel.cartGetProtocol = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        if revealViewController() != nil{
            menuButton.target = self.revealViewController()
            if MOLHLanguage.isArabic() {
                menuButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            } else {
                menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            }
        }
        
        SVProgressHUD.show()
        cartGetModel.getCart()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func onGettingCartSuccess(order: Order) {
        self.order = order
        UserDefUtil.saveOrder(order: order)
        orderItems = order.orderItems!
        SVProgressHUD.dismiss()
//        self.orderTotalPrice = Double(order.subTotal!)!
        self.tableView.reloadData()
        if orderItems.count == 0 {
            self.orderTotalPrice = 0
            self.subTotal.text = "0"
            self.deliveryLabel.text = "0"
            self.totalPrice.text = "0"
        } else {
            self.orderTotalPrice = Double(order.subTotal!)!
            self.subTotal.text = order.subTotal
            self.deliveryLabel.text = order.delivery
            self.totalPrice.text = order.total
        }
    }

    func onGettingCartError(message: String) {
        print(message)
        SVProgressHUD.dismiss()
    }
    
    func onPlaceOrderSuccess(order: Order) {
        if order_now_action {
            SVProgressHUD.dismiss()
            order_now_action = false
            goToCompleteOrder()
        } else {
            order_now_action = false
        }
    }
    
    func onPlaceOrderError(message: String, product: Product) {
        SVProgressHUD.dismiss()
        let product_new: Product? = product
        if product_new == nil {
            
            let alert = UIAlertController(title: "FishDay".localized, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK".localized, style: UIAlertAction.Style.default, handler:  { action in
                print("order input empty ..")
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            if order_now_action {
                let message_new = "\("order_error_prefix_first".localized) \(product_new!.quantity_count ?? 0) \("order_error_prefix_second".localized) '\(product_new!.name ?? "")' \("order_error_perfix".localized)"
                let alert = UIAlertController(title: "FishDay".localized, message: message_new, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK".localized, style: UIAlertAction.Style.default, handler:  { action in
                    print("order input empty ..")
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    func onDeleteOrderItemSuccess(message: String) {
        print (message)
        SVProgressHUD.dismiss()
    }
    
    func onDeleteOrderItemError(message: String) {
        print (message)
        SVProgressHUD.dismiss()
    }
    
    func onGettingCartUpdateSuccess(product: Product) {
        
    }
    
    func onGettingCartUpdateError(message: String) {
        
    }
    
    func onIncreaseQuantity(orderItem: OrderItem, index: Int) {
        let newQuantity = Double((orderItem.quantity)! + 1)
        let newTotalPrice: Double = newQuantity * Double((orderItem.unitPrice)!)!
        orderItem.quantity = Int(newQuantity)
        orderItem.totalPrice = "\(newTotalPrice)"
        print ("Increase")
        tableView.reloadData()
        updateOrderTotalPrice(orderItem: orderItem, increase: true)
        let order = Order()
        order.orderItems = self.orderItems
        order_now_action = false
        cartModel.cartUpdate(orderId: self.order.id!, order: order)
    }
    
    func onDecreaseQuantity(orderItem: OrderItem, index: Int) {
        if orderItem.quantity == 1 {
            return
        }
        let newQuantity = Double((orderItem.quantity)! - 1)
        let newTotalPrice: Double = newQuantity * Double((orderItem.unitPrice)!)!
        orderItem.quantity = Int(newQuantity)
        orderItem.totalPrice = "\(newTotalPrice)"
        print ("Decrease")
        tableView.reloadData()
        updateOrderTotalPrice(orderItem: orderItem, increase: false)
        let order = Order()
        order.orderItems = self.orderItems
        order_now_action = false
        cartModel.cartUpdate(orderId: self.order.id!, order: order)
    }
    
    func onDeleteItem(orderItem: OrderItem, index: Int) {
        SVProgressHUD.show()
        orderItems.remove(at: index)
        cartModel.deleteOrderItem(orderItemId: orderItem.id!)
        // >  Hajor --update total price labels.
       
        tableView.reloadData()
        print ("Delete")
       updateOrderTotalPriceLabels(orderItem: orderItem)
    }
    
    private func updateOrderTotalPrice(orderItem: OrderItem, increase: Bool) {
        let unitPrice: Double = Double(orderItem.unitPrice!)!
        if (increase){
            self.orderTotalPrice += unitPrice
        }else{
            self.orderTotalPrice -= unitPrice
        }
        self.subTotal.text = "\(self.orderTotalPrice)"
//        self.tax.text = "\((orderTotalPrice * 5 / 100))"
//        self.totalPrice.text = "\(orderTotalPrice + (orderTotalPrice * 5 / 100))"
        let order: Order = UserDefUtil.getOrder()
        let delivery = Double(order.delivery!)
        self.deliveryLabel.text = "\(delivery ?? 0)"
        self.totalPrice.text = "\(self.orderTotalPrice + delivery!)"
    }
    
    //>---hajor-----
    private func updateOrderTotalPriceLabels(orderItem: OrderItem) {
         let unitPrice: Double = Double(orderItem.unitPrice!)!
        let  unitQty: Double = Double(orderItem.quantity!)
        
     
            self.orderTotalPrice -= Double(unitPrice * unitQty)
       
        self.subTotal.text = "\(self.orderTotalPrice)"
        //        self.tax.text = "\((orderTotalPrice * 5 / 100))"
        //        self.totalPrice.text = "\(orderTotalPrice + (orderTotalPrice * 5 / 100))"
        let order: Order = UserDefUtil.getOrder()
        let delivery = Double(order.delivery!)
        if self.orderTotalPrice == 0.0 {
            
            self.deliveryLabel.text = "\(0.0)"
            self.totalPrice.text = "\(self.orderTotalPrice)"
        }else{
            self.deliveryLabel.text = "\(delivery ?? 0)"
            self.totalPrice.text = "\(self.orderTotalPrice + delivery!)"
        }
        
    }
    
    @IBAction func orderNow(_ sender: UIButton) {
        if orderItems.count == 0 {
            showAlert(withMessage: "Cart is empty".localized)
            return
        } else {
            let delivery = Double(order.delivery!)
            if orderTotalPrice + delivery! < 100 {
                showAlert(withMessage: "Order cost should be more than 100 SAR".localized)
                return
            }

        }
        order_now_action = true
        SVProgressHUD.show()
        let order = Order()
        order.orderItems = self.orderItems
        cartModel.placeOrder(orderId: self.order.id!, order: order)
    }
    
    func goToCompleteOrder() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let completeOrderViewController = storyBoard.instantiateViewController(withIdentifier: "CompleteOrderViewController") as! CompleteOrderViewController
        navigationController?.pushViewController(completeOrderViewController, animated: true)
    }
    
    func showAlert(withMessage message: String,andTitle title: String? = nil,shouldShowCancelButton : Bool? = false,withOkAction acceptAction: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK".localized, style: UIAlertAction.Style.default, handler: {action in
            if acceptAction != nil {
                acceptAction!()
            }
            alert.dismiss(animated: true, completion: nil)
        }))
        
        if shouldShowCancelButton! {
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        }
        present(alert, animated: true, completion: nil)
    }
    

}

extension CartViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderItems.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath)
            as! CartTableViewCell
        let orderItem = orderItems[indexPath.row]
        cell.orderItem = orderItem
        cell.cartProtocol = self
        cell.indexPath = indexPath
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print("Clickkkk")
    }
}
