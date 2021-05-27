//
//  ProductDetailsViewController.swift
//  FishDay
//
//  Created by Anas Sherif on 3/16/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import UIKit
import PopupDialog
import ImageSlideshow
import Alamofire
import AlamofireImage
import AppsFlyerLib
import MOLH
import SVProgressHUD
import DropDown
import WebKit

class ProductDetailsViewController: UIViewController, ProductDetailProtocol, CreateOrderItemProtocol, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet var topNameLabel: UILabel!
    @IBOutlet weak var imagePager: ImageSlideshow!
    
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var perPieceLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var perKiloLabel: UILabel!
    
    @IBOutlet weak var piecePriceLabel: UILabel!
    @IBOutlet weak var kiloPriceLabel: UILabel!
    @IBOutlet var soldoutImageView: UIImageView!
    @IBOutlet var originKiloPriceLabel: UILabel!
    @IBOutlet var originPiecePriceLabel: UILabel!
    @IBOutlet var originKiloUnitLabel: UILabel!
    @IBOutlet var originPieceUnitLabel: UILabel!
    @IBOutlet var totalPriceUIView: UIView!
    
    @IBOutlet var baseUnitUIView: UIView!
    @IBOutlet var baseUnitUIViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var baseUnitTitleUIView: UIView!
    @IBOutlet var baseUnitTitleLabel: UILabel!
    @IBOutlet var baseUnitValueUIView: UIView!
    @IBOutlet var baseUnitValueLabel: UILabel!
    @IBOutlet var cleaningUIView: UIView!
    @IBOutlet var cleaningUIViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var cleaningTitleUIView: UIView!
    @IBOutlet var cleaningTitleLabel: UILabel!
    @IBOutlet var cleaningValueUIView: UIView!
    @IBOutlet var cleaningValueLabel: UILabel!
    @IBOutlet var seasoningUIView: UIView!
    @IBOutlet var seasoningUIViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var seasoningTitleUIView: UIView!
    @IBOutlet var seasoningTitleLabel: UILabel!
    @IBOutlet var seasoningValueUIView: UIView!
    @IBOutlet var seasoningValueLabel: UILabel!
    @IBOutlet var packagingUIView: UIView!
    @IBOutlet var packagingUIViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var packagingTitleUIView: UIView!
    @IBOutlet var packagingTitleLabel: UILabel!
    @IBOutlet var packagingValueUIView: UIView!
    @IBOutlet var packagingValueLabel: UILabel!
    
    @IBOutlet var suggestedProductsTitleLabel: UILabel!
    
    @IBOutlet var counterLabel: UILabel!
    @IBOutlet var totalPriceLabel: UILabel!
    
    @IBOutlet var relatedProductsCollectionView: UICollectionView!
    
    @IBOutlet var reviewTableView: UITableView!
    @IBOutlet var reviewTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var reviewUITextView: UITextView!
    
    
    var selected_baseunit = "kilo" // kilo or piece
    var selected_cleaning = 0
    var selected_seasoning = 0
    var selected_packaging = 0
    
    var productDetailModel = ProductDetailModel()
    var createOrderItemModel = CreateOrderItemModel()
    
    var product: Product?
  //  var imagesArray = []()
    var imagesArray = [AlamofireSource]()
    
    var productId: String? = ""
    
    // for cart
    var order: Order?
    var orderItem = OrderItem()
    
    @IBOutlet var webView: WKWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.load(URLRequest(url: URL(string: "https://avataaars.io/?accessoriesType=Prescription01&avatarStyle=Circl&clotheColor=PastelBlue&clotheType=ShirtCrewNeck&eyeType=EyeRoll&eyebrowType=SadConcernedNatural&facialHairColor=BrownDark&facialHairType=Red&hairColor=PastelPink&hatColor=PastelRed&mouthType=Serious&skinColor=Pale&topType=LongHairCurvy")!))
        
        productDetailModel.productDetailProtocol = self
        createOrderItemModel.createOrderItemProtocol = self
        
        addToCartButton.setTitle("AddToCart".localized, for: .normal)
        
        self.soldoutImageView.isHidden = true
        
        self.totalPriceUIView.layer.borderWidth = 1
        self.totalPriceUIView.layer.borderColor = UIColor(hexString: "0096FF").cgColor
        self.totalPriceUIView.layer.masksToBounds = true
        
        self.baseUnitTitleUIView.layer.borderWidth = 1
        self.baseUnitTitleUIView.layer.borderColor = UIColor(hexString: "0096FF").cgColor
        self.baseUnitTitleUIView.layer.masksToBounds = true
        self.baseUnitValueUIView.layer.borderWidth = 1
        self.baseUnitValueUIView.layer.borderColor = UIColor(hexString: "0096FF").cgColor
        self.baseUnitValueUIView.layer.masksToBounds = true
        baseUnitTitleLabel.text = "BaseUnit".localized
        
        self.cleaningTitleUIView.layer.borderWidth = 1
        self.cleaningTitleUIView.layer.borderColor = UIColor(hexString: "0096FF").cgColor
        self.cleaningTitleUIView.layer.masksToBounds = true
        self.cleaningValueUIView.layer.borderWidth = 1
        self.cleaningValueUIView.layer.borderColor = UIColor(hexString: "0096FF").cgColor
        self.cleaningValueUIView.layer.masksToBounds = true
        cleaningTitleLabel.text = "Cleaning".localized
        
        self.seasoningTitleUIView.layer.borderWidth = 1
        self.seasoningTitleUIView.layer.borderColor = UIColor(hexString: "0096FF").cgColor
        self.seasoningTitleUIView.layer.masksToBounds = true
        self.seasoningValueUIView.layer.borderWidth = 1
        self.seasoningValueUIView.layer.borderColor = UIColor(hexString: "0096FF").cgColor
        self.seasoningValueUIView.layer.masksToBounds = true
        seasoningTitleLabel.text = "Seasoning".localized
        
        self.packagingTitleUIView.layer.borderWidth = 1
        self.packagingTitleUIView.layer.borderColor = UIColor(hexString: "0096FF").cgColor
        self.packagingTitleUIView.layer.masksToBounds = true
        self.packagingValueUIView.layer.borderWidth = 1
        self.packagingValueUIView.layer.borderColor = UIColor(hexString: "0096FF").cgColor
        self.packagingValueUIView.layer.masksToBounds = true
        packagingTitleLabel.text = "Packaging".localized
        
        suggestedProductsTitleLabel.text = "SuggestedProducts".localized

        self.nameLabel.isHidden = true
        self.descLabel.isHidden = true
        self.perPieceLabel.isHidden = true
        self.perKiloLabel.isHidden = true
        self.piecePriceLabel.isHidden = true
        self.kiloPriceLabel.isHidden = true
        self.originKiloPriceLabel.isHidden = true
        self.originPiecePriceLabel.isHidden = true
        self.originKiloUnitLabel.isHidden = true
        self.perPieceLabel.isHidden = true
        self.originPieceUnitLabel.isHidden = true
        self.addToCartButton.isHidden = true
        
        self.reviewUITextView.layer.borderWidth = 1
        self.reviewUITextView.layer.cornerRadius = 5
        self.reviewUITextView.layer.borderColor = UIColor(hexString: "0096FF").cgColor
        self.reviewUITextView.layer.masksToBounds = true
        
        self.reviewTableView.estimatedRowHeight = 50
        self.reviewTableView.rowHeight = UITableView.automaticDimension
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        self.order = UserDefUtil.getOrder()
        
        var lang = "en";
        if MOLHLanguage.isArabic() {
            lang = "ar"
        }
        SVProgressHUD.show()
        productDetailModel.getProductDetail(productID: String((self.product?.id)!), lang: lang)
        

        UserDefUtil.saveUniversalProductID(productID: "")
        
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }

    
    private func displayProductInfo() {
        
        // shows all field
        self.nameLabel.isHidden = false
        self.descLabel.isHidden = false
        self.perPieceLabel.isHidden = false
        self.perKiloLabel.isHidden = false
        self.piecePriceLabel.isHidden = false
        self.kiloPriceLabel.isHidden = false
        self.originKiloPriceLabel.isHidden = false
        self.originPiecePriceLabel.isHidden = false
        self.originKiloUnitLabel.isHidden = false
        self.perPieceLabel.isHidden = false
        self.originPieceUnitLabel.isHidden = false
        self.addToCartButton.isHidden = false
        
        topNameLabel.text = product?.name
        nameLabel.text = product?.name
        descLabel.text = product?.desc
        imagesArray.removeAll()
        if let productImages = product?.images {
            if productImages.count > 0 {
                for item  in productImages {
                     imagesArray.append(AlamofireSource(urlString: item.small!)!)
                   // print(imagesArray.)
                   // imagesArray.append(ImageSlideshowItem(JSONString: item.small!)!)
                }
            }
        }
        imagePager.setImageInputs(imagesArray)
        imagePager.contentScaleMode = .scaleToFill
//        imagePager.setImageInputs([
//            ImageSource(image: #imageLiteral(resourceName: "fish") ),
//            ImageSource(image: #imageLiteral(resourceName: <#T##String#>))
//            AlamofireSource(urlString: "https://images.unsplash.com/photo-1432679963831-2dab49187847?w=1080"),
//            KingfisherSource(urlString: "https://images.unsplash.com/photo-1432679963831-2dab49187847?w=1080"),
//            ParseSource(file: PFFile(name:"image.jpg", data:data))
//            ])

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTap))
        imagePager.addGestureRecognizer(gestureRecognizer)
        
        self.cleaningValueLabel.text = "Clean".localized
        self.seasoningValueLabel.text = "No".localized
        self.packagingValueLabel.text = "Vacuumpackaging".localized
        
        if(self.product?.category?.additional_info == "yes") {
            self.cleaningUIView.isHidden = false
            self.cleaningUIViewHeightConstraint.constant = 40
            self.seasoningUIView.isHidden = false
            self.seasoningUIViewHeightConstraint.constant = 40
            self.packagingUIView.isHidden = false
            self.packagingUIViewHeightConstraint.constant = 40
        } else {
            self.cleaningUIView.isHidden = true
            self.cleaningUIViewHeightConstraint.constant = 0
            self.seasoningUIView.isHidden = true
            self.seasoningUIViewHeightConstraint.constant = 0
            self.packagingUIView.isHidden = true
            self.packagingUIViewHeightConstraint.constant = 0
        }
        
        if self.product?.quantity_type == "piece" {
            self.kiloPriceLabel.isHidden = false
            self.perKiloLabel.isHidden = false
            self.originKiloPriceLabel.isHidden = true
            self.originKiloUnitLabel.isHidden = true
            self.piecePriceLabel.isHidden = true
            self.perPieceLabel.isHidden = true
            self.originPiecePriceLabel.isHidden = true
            self.originPieceUnitLabel.isHidden = true
            perKiloLabel.text = "PerPiece".localized
            baseUnitValueLabel.text = "PerPiece".localized
            selected_baseunit = "piece"
            
            if Float((product?.piecePrice)! as String) == 0 || Float((product?.piecePrice)! as String) == nil {
                self.kiloPriceLabel.isHidden = true
                self.perKiloLabel.isHidden = true
            } else {
                if(product?.promotion_piece_price != nil && Float((product?.promotion_piece_price)! as String) != nil && Float((product?.promotion_piece_price)! as String) != 0) {
                    let first = Float((product?.piecePrice)! as String)!
                    let promotion = Float((product?.promotion_piece_price)! as String)!
                    let real_price = first - promotion
                    let priceAttribute: NSMutableAttributedString =  NSMutableAttributedString(string: product!.piecePrice!)
                    priceAttribute.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, priceAttribute.length))
                    originKiloPriceLabel.attributedText = priceAttribute
                    originKiloUnitLabel.text = "PerPiece".localized
                    kiloPriceLabel.text = String(real_price)
                    self.originKiloPriceLabel.isHidden = false
                    self.originKiloUnitLabel.isHidden = false
                    
                    self.totalPriceLabel.text = String(real_price)
                } else {
                    kiloPriceLabel.text = product?.piecePrice
                    self.totalPriceLabel.text = product?.piecePrice
                }
            }
        } else if self.product?.quantity_type == "kilo" {
            self.kiloPriceLabel.isHidden = false
            self.perKiloLabel.isHidden = false
            self.originKiloPriceLabel.isHidden = true
            self.originKiloUnitLabel.isHidden = true
            self.piecePriceLabel.isHidden = true
            self.perPieceLabel.isHidden = true
            self.originPiecePriceLabel.isHidden = true
            self.originPieceUnitLabel.isHidden = true
            perKiloLabel.text = "PerKilo".localized
            baseUnitValueLabel.text = "PerKilo".localized
            selected_baseunit = "kilo"
           
            if Float((product?.kiloPrice)! as String) == 0 || Float((product?.kiloPrice)! as String) == nil {
                self.kiloPriceLabel.isHidden = true
                self.perKiloLabel.isHidden = true
            } else {
                if(product?.promotion_kilo_price != nil && Float((product?.promotion_kilo_price)! as String) != nil && Float((product?.promotion_kilo_price)! as String) != 0) {
                    let first = Float((product?.kiloPrice)! as String)!
                    let promotion = Float((product?.promotion_kilo_price)! as String)!
                    let real_price = first - promotion
                    let priceAttribute: NSMutableAttributedString =  NSMutableAttributedString(string: product!.kiloPrice!)
                    priceAttribute.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, priceAttribute.length))
                    originKiloPriceLabel.attributedText = priceAttribute
                    originKiloUnitLabel.text = "PerKilo".localized
                    kiloPriceLabel.text = String(real_price)
                    self.originKiloPriceLabel.isHidden = false
                    self.originKiloUnitLabel.isHidden = false
                    
                    self.totalPriceLabel.text = String(real_price)
                } else {
                    kiloPriceLabel.text = product?.kiloPrice
                    self.totalPriceLabel.text = product?.kiloPrice
                }
            }
        } else { // for all
            self.kiloPriceLabel.isHidden = false
            self.perKiloLabel.isHidden = false
            self.perPieceLabel.isHidden = false
            self.perPieceLabel.isHidden = false
            perKiloLabel.text = "PerKilo".localized
            kiloPriceLabel.text = product?.kiloPrice
            perPieceLabel.text = "PerPiece".localized
            piecePriceLabel.text = product?.piecePrice
            self.originKiloPriceLabel.isHidden = true
            self.originKiloUnitLabel.isHidden = true
            self.originPiecePriceLabel.isHidden = false
            self.originPieceUnitLabel.isHidden = false
            baseUnitValueLabel.text = "PerKilo".localized
            selected_baseunit = "kilo"
            
            if Float((product?.kiloPrice)! as String) == 0 || Float((product?.kiloPrice)! as String) == nil {
                self.piecePriceLabel.isHidden = true
                self.perPieceLabel.isHidden = true
                perKiloLabel.text = "PerPiece".localized
                kiloPriceLabel.text = product?.piecePrice
                baseUnitValueLabel.text = "PerPiece".localized
                selected_baseunit = "piece"
            } else {
                if(product?.promotion_kilo_price != nil && Float((product?.promotion_kilo_price)! as String) != nil && Float((product?.promotion_kilo_price)! as String) != 0) {
                    let first = Float((product?.kiloPrice)! as String)!
                    let promotion = Float((product?.promotion_kilo_price)! as String)!
                    let real_price = first - promotion
                    let priceAttribute: NSMutableAttributedString =  NSMutableAttributedString(string: product!.kiloPrice!)
                    priceAttribute.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, priceAttribute.length))
                    originKiloPriceLabel.attributedText = priceAttribute
                    kiloPriceLabel.text = String(real_price)
                    self.originKiloPriceLabel.isHidden = false
                    self.originKiloUnitLabel.isHidden = false
                    
                    self.totalPriceLabel.text = String(real_price)
                } else {
                    kiloPriceLabel.text = product?.kiloPrice
                    self.totalPriceLabel.text = product?.kiloPrice
                }
            }
            
            if Float((product?.piecePrice)! as String) == 0 || Float((product?.piecePrice)! as String) == nil {
                self.piecePriceLabel.isHidden = true
                self.perPieceLabel.isHidden = true
            } else {
                if(product?.promotion_piece_price != nil && Float((product?.promotion_piece_price)! as String) != nil && Float((product?.promotion_piece_price)! as String) != 0) {
                    let first = Float((product?.piecePrice)! as String)!
                    let promotion = Float((product?.promotion_piece_price)! as String)!
                    let real_price = first - promotion
                    let priceAttribute: NSMutableAttributedString =  NSMutableAttributedString(string: product!.piecePrice!)
                    priceAttribute.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, priceAttribute.length))
                    originPiecePriceLabel.attributedText = priceAttribute
                    piecePriceLabel.text = String(real_price)
                    self.originPiecePriceLabel.isHidden = false
                    self.originPieceUnitLabel.isHidden = false
                    
                    self.totalPriceLabel.text = String(real_price)
                } else {
                    piecePriceLabel.text = product?.piecePrice
                    self.totalPriceLabel.text = product?.piecePrice
                }
            }
        }
        if (product?.quantity_count)! > 0 {
            self.soldoutImageView.isHidden = true
        } else {
            self.soldoutImageView.isHidden = false
        }
        if MOLHLanguage.isArabic() {
            self.soldoutImageView.image = UIImage(named: "soldout_ar")
        } else {
            self.soldoutImageView.image = UIImage(named: "soldout_en")
        }
        
        var product_price:Float = 0
        if self.product?.quantity_type == "piece" {
            product_price = Float((self.product?.piecePrice)!)!
        } else if self.product?.quantity_type == "kilo" {
            product_price = Float((self.product?.kiloPrice)!)!
        } else { // for all
            if Float((product?.kiloPrice)! as String) != 0 && Float((product?.kiloPrice)! as String) != nil {
                 product_price = Float((self.product?.piecePrice)!)!
            } else if Float((product?.piecePrice)! as String) != 0 && Float((product?.piecePrice)! as String) != nil {
                product_price = Float((self.product?.kiloPrice)!)!
            }
        }
        let product_name = self.product?.name
        
        self.product?.reviews = []
        self.product?.reviews?.append(Review(rating: 3.5, review: "first review"))
        self.product?.reviews?.append(Review(rating: 5, review: "second review"))
        self.product?.reviews?.append(Review(rating: 4, review: "this is long text review so we can test long text. this is long text review so we can test long text. this is long text review so we can test long text. this is long text review so we can test long text."))
        if self.product?.reviews?.count == 0 {
            self.reviewTableViewHeightConstraint.constant = 0
        } else {
            self.reviewTableViewHeightConstraint.constant = 10
        }
        self.reviewTableView.reloadData()
        
        AppsFlyerTracker.shared().trackEvent(AFEventContentView,
           withValues: [
            AFEventParamPrice: product_price,
            AFEventParamContentId: String(describing: self.product?.id!),
            AFEventParamContentType: product_name!,
            AFEventParamCurrency: "SAR"
        ]);
    }
    
    @objc func didTap() {
        imagePager.presentFullScreenController(from: self)
    }
    
    
    func onGettingProductDetailSuccess(product: Product) {
        SVProgressHUD.dismiss()
        self.product = product
        self.displayProductInfo()
        self.relatedProductsCollectionView.reloadData()
    }
    
    func onGettingProductDetailError(message: String) {
        SVProgressHUD.dismiss()
        print("product detail error")
    }
    
    @IBAction func baseUnitDropdownButtonAction(_ sender: UIButton) {
        let dropDown = DropDown()
        dropDown.anchorView = sender
        if self.product?.quantity_type == "kilo" {
            dropDown.dataSource = ["PerKilo".localized]
        } else if self.product?.quantity_type == "piece" {
            dropDown.dataSource = ["PerPiece".localized]
        } else { // for all
            dropDown.dataSource = ["PerKilo".localized, "PerPiece".localized]
        }
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.baseUnitValueLabel.text = item
            if self.product?.quantity_type == "kilo" {
                self.selected_baseunit = "kilo"
            } else if self.product?.quantity_type == "piece" {
                self.selected_baseunit = "piece"
            } else { // for all
                if index == 0 {
                    self.selected_baseunit = "kilo"
                } else {
                    self.selected_baseunit = "piece"
                }
            }
            let product_count = Int(self.counterLabel.text!)!
            self.totalPriceLabel.text = String(self.calc_totalPrice(count: product_count))
        }
        dropDown.show()
    }
    
    @IBAction func cleaningDropdownButtonAction(_ sender: UIButton) {
        let dropDown = DropDown()
        dropDown.anchorView = sender
        dropDown.dataSource = ["Clean".localized, "Barbecue".localized, "Cutting".localized]
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.cleaningValueLabel.text = item
            self.selected_cleaning = index
        }
        dropDown.show()
    }
    
    @IBAction func seasoningDropdownButtonAction(_ sender: UIButton) {
        let dropDown = DropDown()
        dropDown.anchorView = sender
        dropDown.dataSource = ["No".localized, "Yes".localized]
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            var total_price = Float(self.totalPriceLabel.text!)!
            let count = Int(self.counterLabel.text!)!
            if self.selected_seasoning != index {
                if index == 0 {
                    total_price = total_price - 2 * Float(count)
                } else {
                    total_price = total_price + 2 * Float(count)
                }
                self.seasoningValueLabel.text = item
                self.selected_seasoning = index
                self.totalPriceLabel.text = String(total_price)
            }
        }
        dropDown.show()
    }
    
    @IBAction func packagingDropdownButtonAction(_ sender: UIButton) {
        let dropDown = DropDown()
        dropDown.anchorView = sender
        dropDown.dataSource = ["Vacuumpackaging".localized, "Foamplates".localized]
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.packagingValueLabel.text = item
            self.selected_packaging = index
        }
        dropDown.show()
    }
    
    @IBAction func counterPlusButtonAction(_ sender: Any) {
        var count = Int(self.counterLabel.text!)!
        count = count + 1
        self.counterLabel.text = String(count)
        self.totalPriceLabel.text = String(self.calc_totalPrice(count: count))
    }
    
    @IBAction func counterMinusButtonAction(_ sender: Any) {
        var count = Int(self.counterLabel.text!)!
        if count > 1 {
            count = count - 1
            self.counterLabel.text = String(count)
            self.totalPriceLabel.text = String(self.calc_totalPrice(count: count))
        }
    }
    
    func calc_totalPrice(count: Int) -> Float {
        var total_price:Float = 0
        if selected_baseunit == "kilo" {
            if Float((product?.kiloPrice)! as String) != nil || Float((product?.kiloPrice)! as String) != 0 {
                var price = Float((product?.kiloPrice)! as String)!
                if(product?.promotion_kilo_price != nil && Float((product?.promotion_kilo_price)! as String) != nil && Float((product?.promotion_kilo_price)! as String) != 0) {
                    price = price - Float((product?.promotion_kilo_price)! as String)!
                }
                total_price = price * Float(count)
            }
        } else {
            if Float((product?.piecePrice)! as String) != nil || Float((product?.piecePrice)! as String) != 0 {
                var price = Float((product?.piecePrice)! as String)!
                if(product?.promotion_piece_price != nil && Float((product?.promotion_piece_price)! as String) != nil && Float((product?.promotion_piece_price)! as String) != 0) {
                    price = price - Float((product?.promotion_piece_price)! as String)!
                }
                total_price = price * Float(count)
            }
        }
        if total_price != 0 {
            if selected_seasoning == 1 {
                total_price = total_price + 2 * Float(count)
            }
        }
        return total_price
    }
    
    @IBAction func addToCartAction(_ sender: UIButton) {
        self.orderItem.orderId = order?.id
        self.orderItem.productId = self.product?.id
        self.orderItem.product = self.product
        self.orderItem.quantity = Int(self.counterLabel.text!)
        if self.selected_baseunit == "kilo" {
            self.orderItem.quantityType = 0
        } else {
            self.orderItem.quantityType = 1
        }
        self.orderItem.cuttingWay = self.selected_cleaning
        self.orderItem.seasoning = self.selected_seasoning
        self.orderItem.packaging = self.selected_packaging
        
        SVProgressHUD.show()
        self.createOrderItemModel.createOrderItem(orderItem: self.orderItem)
    }
    
    func onCreatingOrderItemSuccess(order: Order) {
        if SVProgressHUD.isVisible() {
            SVProgressHUD.dismiss()
        }
        
        // AppsFly
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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CartNavigation")
        self.revealViewController().frontViewController = vc
        
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
    
    func goToFullScreenImage(imageUrl : String)  {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let fullScreenImageViewController = storyBoard.instantiateViewController(withIdentifier: "FullScreenImageViewController") as! FullScreenImageViewController
        navigationController?.pushViewController(fullScreenImageViewController, animated: true)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.product != nil && self.product?.related_products != nil {
            return (self.product?.related_products!.count)!
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RelatedProductCollectionViewCell", for: indexPath) as! RelatedProductCollectionViewCell
        
        let product = self.product?.related_products![indexPath.row]

        cell.product = product
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.frame.size.height * 1.3, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0.0, right: 0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var lang = "en";
        if MOLHLanguage.isArabic() {
            lang = "ar"
        }
        SVProgressHUD.show()
        productDetailModel.getProductDetail(productID: String((self.product?.related_products![indexPath.row].id)!), lang: lang)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.product?.reviews == nil {
            return 0
        }
        return (self.product?.reviews!.count)!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        reviewTableViewHeightConstraint.constant = reviewTableView.contentSize.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell", for: indexPath)
            as! ReviewTableViewCell
        cell.ratingView.rating = (self.product?.reviews![indexPath.row].rating)!
        cell.reviewLabel.text = self.product?.reviews![indexPath.row].review
        
        let accessoryType = "accessoriesType=" + Constant.accessoriesTypeOptions[Int.random(in: 0..<Constant.accessoriesTypeOptions.count)]
        let avatarStyle = "&avatarStyle=Circl"
        let clotheColor = "&clotheColor=" + Constant.clotheColorOptions[Int.random(in: 0..<Constant.clotheColorOptions.count)]
        let clotheType = "&clotheType=" + Constant.clotheTypeOptions[Int.random(in: 0..<Constant.clotheTypeOptions.count)]
        let eyeType = "&eyeType=" + Constant.eyeTypeOptions[Int.random(in: 0..<Constant.eyeTypeOptions.count)]
        let eyebrowType = "&eyebrowType=" + Constant.eyebrowTYpeOptions[Int.random(in: 0..<Constant.eyebrowTYpeOptions.count)]
        let facialHairColor = "&facialHairColor=" + Constant.facialHairColorOptions[Int.random(in: 0..<Constant.facialHairColorOptions.count)]
        let facialHairType = "&facialHairType=" + Constant.facialHairTypeOptions[Int.random(in: 0..<Constant.facialHairTypeOptions.count)]
        let hairColor = "&hairColor=" + Constant.hairColorTypes[Int.random(in: 0..<Constant.hairColorTypes.count)]
        let hatColor = "&hatColor=" + Constant.hatColorOptions[Int.random(in: 0..<Constant.hatColorOptions.count)]
        let mouthType = "&mouthType=" + Constant.mouthTypeOptions[Int.random(in: 0..<Constant.mouthTypeOptions.count)]
        let skinColor = "&skinColor=" + Constant.skinColorOptions[Int.random(in: 0..<Constant.skinColorOptions.count)]
        let topType = "&topType=" + Constant.topTypeOptions[Int.random(in: 0..<Constant.topTypeOptions.count)]
        
        let rnd_image_url = Constant.RANDOM_IMAGE_URL + accessoryType + avatarStyle + clotheColor + clotheType + eyeType + eyebrowType + facialHairColor + facialHairType + hairColor + hatColor + mouthType + skinColor + topType
        
//        cell.avatarImageView.af_setImage(withURL: URL(string: rnd_image_url)!)
        
//        Alamofire.request(rnd_image_url).responseImage { response in
//            debugPrint(response)
//
//            print(response.request)
//            print(response.response)
//            debugPrint(response.result)
//
//            if case .success(let image) = response.result {
//                print("image downloaded: \(image)")
//            }
//        }
        
        return cell
    }
    
}
