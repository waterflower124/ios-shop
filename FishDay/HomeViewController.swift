//
//  HomeViewController.swift
//  FishDay
//
//  Created by Muhammad Kamal on 2/17/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import PopupDialog
import LMGaugeView
import MOLH
import SFGaugeView
import OneSignal


class HomeViewController : UIViewController, HomeProtocol, CartGetProtocol, LastOrderGetProtocol {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    let notificationButton = SSBadgeButton()
    
    func addCartBarButton() {
        notificationButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        notificationButton.setImage(UIImage(named: "menu_cart")?.withRenderingMode(.alwaysTemplate), for: .normal)
        notificationButton.addTarget(self, action: #selector(self.openCart), for: .touchUpInside)
        notificationButton.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 15)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: notificationButton)
        let order = UserDefUtil.getOrder()
        if let count = order.orderItems?.count {
            notificationButton.badge = "\(count)"
        } else {
            notificationButton.badge = "0"
        }
    }
    
    @objc func openCart() {
        lastOrderGetModel.getLastOrder()
    }
    
    func onGettingOffersSuccess(products: [Product]) {
        self.offersArray = products
        self.offersCollectionView.reloadData()
        startTimer()
    }

    func onGettingOffersError(message: String) {
        print(message)
    }
    func onGettingCategoriesSuccess(categories: [Category]) {
        if categories.count > 0
        {
            homeModel.getProductsByCategory(categoryId: categories[0].id!)
            categories[0].isSelected = true
        }
        self.categoriesArray = categories
        self.categoriesCollectionView.reloadData()
    }
    
    func onGettingCategoriesError(message: String) {
        print(message)
    }

    func onGettingLastOrderSuccess(order: Order?) {
        if order == nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CartNavigation")
    //        let navController =  UINavigationController(rootViewController: vc)
            self.revealViewController().frontViewController = vc
        } else {
            if order!.status != 1 && order!.status != 2 && order!.status != 3 {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "CartNavigation")
        //        let navController =  UINavigationController(rootViewController: vc)
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
    
    func onGettingMeterSuccess(meter: Meter) {
        // Handle Meter view
        speedometerView.value = CGFloat(meter.percentage ?? 0)
    }
    
    func onGettingMeterError(message: String) {
        print(message)
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
    
    
    @IBOutlet weak var speedometerView: LMGaugeView!
    @IBOutlet weak var offersCollectionView: UICollectionView!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var cartBarButton: UIBarButtonItem!
    
    @IBOutlet weak var collectionViewConstrant: NSLayoutConstraint!
    var lastSelectedCategory = 0
    var homeModel = HomeModel()
    var cartGetModel = CartGetModel()
    var lastOrderGetModel = LastOrderGetModel()
    var productList = [Product]()
    var product: Product?
    var categoriesArray = [Category]()
    var offersArray = [Product]()
    
    struct Storyboard {
        static let productCell = "ProductCell"
        static let OffersCollectionViewCell = "OffersCollectionViewCell"
        static let CategoriesCollectionViewCell = "CategoriesCollectionViewCell"

        static let numOfItemsPerRow: CGFloat = 2.0
        static let leftAndRightPaddings: CGFloat = 20.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        let rightBarButtons = self.navigationItem.rightBarButtonItems
//
//        let lastBarButton = rightBarButtons?.last
        
//        lastBarButton?.setBadge(text: "4")

    }
    

    
    var lastLocation = CGPoint(x: 0, y: 0)

    @objc func detectPan(_ recognizer:UIPanGestureRecognizer) {
        let translation  = recognizer.translation(in: self.speedometerView.superview)
        self.speedometerView.center = CGPoint(x: lastLocation.x + translation.x, y: lastLocation.y + translation.y)
    }
    
    override func touchesBegan(_ touches: (Set<UITouch>?), with event: UIEvent!) {
        // Promote the touched view
        self.speedometerView.superview?.bringSubviewToFront(self.speedometerView)
        
        // Remember original location
        lastLocation = self.speedometerView.center
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        addCartBarButton()
        
        let panRecognizer = UIPanGestureRecognizer(target:self, action:#selector(self.detectPan))
        self.speedometerView.gestureRecognizers = [panRecognizer]
        
//        let gauageView = LMGaugeView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
//        gauageView.value = 100
//        self.view.addSubview(gauageView)
//        LMGaugeView *gaugeView = [[LMGaugeView alloc] initWithFrame:frame];
//        gaugeView.value = 40;
//        [self.view addSubview:gaugeView];
    
//        self.navigationController?.navigationItem.rightBarButtonItem?.setBadge(text: "3")
//        cartBarButton.setBadge(text: "2")
        title = "Home".localized
        speedometerView.valueFont = UIFont.boldSystemFont(ofSize: 60)
        speedometerView.value = 0
//        speedometerView.currentLevel = 40
//        speedometerView.maxlevel = 100
//        speedometerView.minlevel = 1
//        speedometerView.needleColor = UIColor.cyan
//        speedometerView.backgroundColor = UIColor.white
//        hideLevel = If set to YES the current level is hidden
        
        if revealViewController() != nil{
            
            menuButton.target = self.revealViewController()
            if MOLHLanguage.isArabic() {
                print("language is ar button action")
                menuButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            } else {
                print("language is en button action------------")
                menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            }
        } else {
            
        }
        homeModel.homeProtocol = self
        cartGetModel.cartGetProtocol = self
        collectionView.dataSource = self
        collectionView.delegate = self
        
        lastOrderGetModel.lastOrderGetProtocol = self
        
        let collectionViewWidth = collectionView?.frame.width
        

//        let itemWidth = (collectionViewWidth! - Storyboard.leftAndRightPaddings) / Storyboard.numOfItemsPerRow
        let itemWidth = (collectionViewWidth!/2) - Storyboard.leftAndRightPaddings

        
     //   let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
      //  layout.itemSize = CGSize(width: itemWidth, height: 305)

        
        homeModel.getCategories()
        homeModel.getOffers()
//        homeModel.getLastOrder()
        homeModel.getMeter()
        
        cartGetModel.getCart()
        
        if UserDefUtil.getUniversalProductID() != "" {
            let segueId = "ProductDetails"
            performSegue(withIdentifier: segueId, sender: self)
        }
        

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func onGettingProductsSuccess(products: [Product]) {
        self.productList = products
        if productList.count > 0 {
            self.descriptionLabel.text = productList[0].category?.description
        }
        self.collectionView.reloadData()
    }
 
    
    
    func onGettingProductsError(message: String) {
        print(message)
    }
    
    private func initProductList()
    {
        productList.append(Product(name: "First", desc: "asdasd", kiloPrice: "20"))
        productList.append(Product(name: "Second", desc: "asdasd", kiloPrice: "20"))
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProductDetails" {
            let productDetailsController = segue.destination as! ProductDetailsViewController
            if UserDefUtil.getUniversalProductID() == "" {
                productDetailsController.product = self.product
            } else {
                productDetailsController.productId = UserDefUtil.getUniversalProductID()
            }
        }
    }
    
    @objc func addToCart(sender : UIButton){
        
        let product = productList[sender.tag]
        if product.quantity_count! > 0 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CreateOrderPopupViewController") as! CreateOrderPopupViewController
            // Create thec  dialog
            vc.product = product
            vc.delegate = self
            let popup = PopupDialog(viewController: vc, buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: true)
            // Present dialog
            present(popup, animated: true, completion: nil)
        }
        
    }
}
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView == offersCollectionView {
            return offersArray.count
        } else if collectionView == categoriesCollectionView {
            return categoriesArray.count
        }
        return productList.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == offersCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.OffersCollectionViewCell, for: indexPath) as! OffersCollectionViewCell
            
            let product = offersArray[indexPath.row]
            
            cell.product = product
            return cell
        } else if collectionView == categoriesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.CategoriesCollectionViewCell, for: indexPath) as! CategoriesCollectionViewCell
            let category = categoriesArray[indexPath.row]
            if category.isSelected {
                cell.categoryLabel.textColor = UIColor.init(hexString: "#0096FF")
                cell.categoryView.backgroundColor = .white
                cell.categoryView.layer.borderWidth = 1
                cell.categoryView.layer.borderColor = UIColor.white.cgColor
                cell.categoryView.layer.cornerRadius = 17
                
            } else {
                cell.categoryView.layer.borderWidth = 1
                cell.categoryView.layer.borderColor = UIColor.white.cgColor
                cell.categoryView.layer.cornerRadius = 17
                cell.categoryLabel.textColor = .white
                cell.categoryView.backgroundColor = UIColor.clear
            }
            cell.category = category
            return cell
        } else {
            if (collectionView.contentOffset.y >= (collectionView.contentSize.height - collectionView.frame.size.height)) {
                print("bottom")
                
//                UIView.animate(withDuration: 2) {
//                     self.collectionViewConstrant.constant = 0
//                    self.offersCollectionView.frame = CGRect(x: 0, y: 50, width: self.offersCollectionView.frame.width, height: 0)
//                }
                
                UIView.animate(withDuration: 2.2, animations: {
                    self.collectionViewConstrant.constant = 0

                })
            } else if (collectionView.contentOffset.y <= (collectionView.contentSize.height - collectionView.frame.size.height)){
                
                
                UIView.animate(withDuration: 2.2, animations: {
                    self.collectionViewConstrant.constant = 150
                    print("top")
                    
                })
            }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.productCell, for: indexPath) as! ProductCell
            
            let product = productList[indexPath.row]
//            cell.orderNowButton.tag = indexPath.row
//            cell.orderNowButton.addTarget(self, action: #selector(self.addToCart(sender:)), for: .touchUpInside)
//            cell.orderNowButton.setTitle("AddToCart".localized, for: .normal)

            cell.product = product
            return cell
        }
    }
    
    func openLink(link:String) {
        UIApplication.shared.openURL(NSURL(string: link)! as URL)
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == offersCollectionView {
            let product = offersArray[indexPath.row]
            openLink(link: product.link!)

        } else if collectionView == categoriesCollectionView {
            categoriesArray[indexPath.row].isSelected = true
            categoriesArray[lastSelectedCategory].isSelected = false
            lastSelectedCategory = indexPath.row
            collectionView.reloadData()
            homeModel.getProductsByCategory(categoryId: categoriesArray[indexPath.row].id!)
        } else {
            let segueId = "ProductDetails"
            self.product = productList[indexPath.row]
            performSegue(withIdentifier: segueId, sender: self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == offersCollectionView {
            return CGSize(width: collectionView.frame.size.width, height: 150)
        } else if collectionView == categoriesCollectionView {
            return CGSize(width: 130, height: 35)
        }
        return CGSize(width: collectionView.frame.size.width, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0.0, right: 0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    
    
//    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if collectionView == offersCollectionView
//        {
//            if indexPath.row == (offersArray.count - 1)
//            {
//                self.offersCollectionView?.scrollToItem(at: IndexPath(row: 0, section: 0),
//                                                        at: .left,
//                                                        animated: true)
//            }
//        }
//    }
    
    /**
     Scroll to Next Cell
     */
    @objc func scrollToNextCell(){
        
        //get cell size
        let cellSize = CGSize(width: offersCollectionView.frame.size.width, height: 150)
        
        //get current content Offset of the Collection view
        let contentOffset = offersCollectionView.contentOffset;

        //scroll to next cell
        
        if MOLHLanguage.isArabic()
        {
            if contentOffset.x == 0
            {
                
                self.offersCollectionView?.scrollToItem(at: IndexPath(row: 0, section: 0),
                                                        at: .right,
                                                        animated: true)
            }
            offersCollectionView.scrollRectToVisible(CGRect(x: contentOffset.x - cellSize.width, y: contentOffset.y, width: cellSize.width, height: cellSize.height), animated: true)
        }
        else
        {
            if contentOffset.x == offersCollectionView.contentOffset.x
            {
                self.offersCollectionView?.scrollToItem(at: IndexPath(row: 0, section: 0),
                                                        at: .right,
                                                        animated: true)
            }
            offersCollectionView.scrollRectToVisible(CGRect(x: contentOffset.x + cellSize.width, y: contentOffset.y, width: cellSize.width, height: cellSize.height), animated: true)
        }
//        if true {
//            self.offersCollectionView?.scrollToItem(at: IndexPath(row: 0, section: 0),
//                                              at: .top,
//                                              animated: true)
//        }
       
       
    }
    
    /**
     Invokes Timer to start Automatic Animation with repeat enabled
     */
    func startTimer() {
        
        _ = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(HomeViewController.scrollToNextCell), userInfo: nil, repeats: true);
        
        
    }
  
    
}
