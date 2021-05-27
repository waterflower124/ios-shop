//
//  RelatedProductCollectionViewCell.swift
//  FishDay
//
//  Created by Water Flower on 11/3/20.
//  Copyright © 2020 Anas Sherif. All rights reserved.
//

import UIKit
import AlamofireImage
import MOLH

class RelatedProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    
    @IBOutlet weak var productKiloPriceLabel: UILabel!
    @IBOutlet weak var productPcPriceLabel: UILabel!
    @IBOutlet weak var kilounitLabel: UILabel!
    @IBOutlet weak var pcunitLabel: UILabel!
    @IBOutlet weak var soldoutImageView: UIImageView!
    @IBOutlet var realKiloPriceLabel: UILabel!
    @IBOutlet var realPiecePriceLabel: UILabel!
    
    var product: Product!{
        didSet{
            self.productNameLabel.text = product.name
            self.kilounitLabel.text = "perkg".localized
            self.pcunitLabel.text = "perpc".localized
            if product.quantity_type == "piece" {
                self.productPcPriceLabel.isHidden = true
                self.pcunitLabel.isHidden = true
                self.productKiloPriceLabel.isHidden = false
                self.kilounitLabel.isHidden = false
                self.realKiloPriceLabel.isHidden = true
                self.realPiecePriceLabel.isHidden = true
                
                self.kilounitLabel.text = "perpc".localized
                if Float(product.piecePrice!) == 0.0 || Float(product.piecePrice!) == nil {
                    self.productKiloPriceLabel.isHidden = true
                    self.kilounitLabel.isHidden = true
                }
                print("piece price:  \(product.piecePrice ?? "null")")
                print("promotion price:  \(product.promotion_piece_price ?? "null")")
                if product.promotion_piece_price != nil && Float(product.promotion_piece_price!) != nil && Float(product.promotion_piece_price!) != 0.0  {
                    
                    let real_price = Float(product.piecePrice!)! - Float(product.promotion_piece_price!)!
                    let piecePriceAttribute: NSMutableAttributedString =  NSMutableAttributedString(string: product.piecePrice!)
                    piecePriceAttribute.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, piecePriceAttribute.length))
                    self.productKiloPriceLabel.text = String(real_price)
                    self.realKiloPriceLabel.isHidden = false
                    self.realKiloPriceLabel.attributedText = piecePriceAttribute
                } else {
                    self.productKiloPriceLabel.text = product.piecePrice
                }
            } else if product.quantity_type == "kilo" {
                self.productPcPriceLabel.isHidden = true
                self.pcunitLabel.isHidden = true
                self.productKiloPriceLabel.isHidden = false
                self.kilounitLabel.isHidden = false
                self.realKiloPriceLabel.isHidden = true
                self.realPiecePriceLabel.isHidden = true
                
//                self.productKiloPriceLabel.text = product.kiloPrice
                self.kilounitLabel.text = "perkg".localized
                if Float(product.kiloPrice!) == 0 || Float(product.kiloPrice!) == nil {
                    self.productKiloPriceLabel.isHidden = true
                    self.kilounitLabel.isHidden = true
                }
                if product.promotion_kilo_price != nil && Float(product.promotion_kilo_price!) != nil && Float(product.promotion_kilo_price!) != 0.0 {
                    let real_price = Float(product.kiloPrice!)! - Float(product.promotion_kilo_price!)!
                    
                    let kiloPriceAttribute: NSMutableAttributedString =  NSMutableAttributedString(string: product.kiloPrice!)
                    kiloPriceAttribute.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, kiloPriceAttribute.length))
                    self.productKiloPriceLabel.text = String(real_price)
                    self.realKiloPriceLabel.isHidden = false
                    self.realKiloPriceLabel.attributedText = kiloPriceAttribute
                } else {
                    self.productKiloPriceLabel.text = product.kiloPrice
                }
            } else { //"all"
                self.productPcPriceLabel.isHidden = false
                self.pcunitLabel.isHidden = false
                self.productKiloPriceLabel.isHidden = false
                self.kilounitLabel.isHidden = false
//                self.productKiloPriceLabel.text = product.kiloPrice
//                self.productPcPriceLabel.text = product.piecePrice
                self.realKiloPriceLabel.isHidden = true
                self.realPiecePriceLabel.isHidden = true
                
                self.kilounitLabel.text = "perpc".localized
                self.kilounitLabel.text = "perkg".localized
                if Float(product.piecePrice!) == 0.0 || Float(product.piecePrice!) == nil {
                    self.productPcPriceLabel.isHidden = true
                    self.pcunitLabel.isHidden = true
                }
                if Float(product.kiloPrice!) == 0 || Float(product.kiloPrice!) == nil {
                    self.productKiloPriceLabel.isHidden = true
                    self.kilounitLabel.isHidden = true
                }
                
                if product.promotion_piece_price != nil && Float(product.promotion_piece_price!) != nil && Float(product.promotion_piece_price!) != 0.0 {
                    let real_PCPrice = Float(product.piecePrice!)! - Float(product.promotion_piece_price!)!
                    let piecePriceAttribute: NSMutableAttributedString =  NSMutableAttributedString(string: product.piecePrice!)
                    piecePriceAttribute.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, piecePriceAttribute.length))
                    self.productPcPriceLabel.text = String(real_PCPrice)
                    self.realPiecePriceLabel.isHidden = false
                    self.realPiecePriceLabel.attributedText = piecePriceAttribute
                } else {
                    self.productPcPriceLabel.text = product.piecePrice
                }
                if product.promotion_kilo_price != nil && Float(product.promotion_kilo_price!) != nil && Float(product.promotion_kilo_price!) != 0.0 {
                    let real_price = Float(product.kiloPrice!)! - Float(product.promotion_kilo_price!)!
                    let kiloPriceAttribute: NSMutableAttributedString =  NSMutableAttributedString(string: product.kiloPrice!)
                    kiloPriceAttribute.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, kiloPriceAttribute.length))
                    self.productKiloPriceLabel.text = String(real_price)
                    self.realKiloPriceLabel.isHidden = false
                    self.realKiloPriceLabel.attributedText = kiloPriceAttribute
                } else {
                    self.productKiloPriceLabel.text = product.kiloPrice
                }
            }
//            self.productPcPriceLabel.text = product.kiloPrice
            if product.images != nil && (product.images?.count)! > 0 {
                if ((product.images?[0].small) != nil) {
                    let downloadURL = URL(string: (product.images?[0].small)!)
                    if downloadURL != nil {
                        self.productImage.af_setImage(withURL: downloadURL!)
                    } else {
                        self.productImage.image = #imageLiteral(resourceName: "fish")
                    }
                }
            }
            if MOLHLanguage.isArabic() {
                self.soldoutImageView.image = UIImage(named: "soldout_ar")
            } else {
                self.soldoutImageView.image = UIImage(named: "soldout_en")
            }
            if product.quantity_count! > 0 {
                self.soldoutImageView.isHidden = true
            } else {
                self.soldoutImageView.isHidden = false
            }
        }
    }
    
}
