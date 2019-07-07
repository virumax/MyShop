//
//  ProductDetailViewController.swift
//  MyShop
//
//  Created by Virendra Ravalji on 2019/7/6.
//  Copyright © 2019 Virendra Ravalji. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {

    var productDetailsViewModel: ProductDetailsViewModelProtocol?
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var color: UILabel!
    @IBOutlet weak var size: UILabel!
    @IBOutlet weak var changeColor: UIButton!
    @IBOutlet weak var changeSize: UIButton!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        
        // Display product details
        showDetails()
        
        // Reduce the height of image view for iPhone 5s
        if UIScreen.main.nativeBounds.size.height <= 1136 {
            heightConstraint.constant = 202
        }
    }
    
    func setupNavigationBar() {
        // Set title
        self.navigationItem.title = productDetailsViewModel?.titleText
    }
    
    func showDetails() {
        name.text = productDetailsViewModel?.product.name
        
        if let variant = productDetailsViewModel?.selectedVariant {
            let rupee = "\u{20B9}"
            price.text = rupee + " " + "\(variant.price)"
            color.text = variant.color
            size.text = String(variant.size)
        } else {
            price.text = MyShop_Strings.NOT_AVAILABLE
        }
    }
    
    //MARK: Private methods
    func showAlert(withTitle: String?, andMessage: String?) {
        let alert = UIAlertController(title: withTitle, message: andMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: MyShop_Strings.OK, style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Action methods
    @IBAction func buyProduct() {
        productDetailsViewModel?.addToCart()
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let cartView = storyBoard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
        let cartViewModel = CartViewModel(title: MyShop_Strings.CART_TITLE)
        cartView.cartViewModel = cartViewModel
        self.navigationController?.pushViewController(cartView, animated: true)
    }
    
    @IBAction func addToCart() {
        productDetailsViewModel?.addToCart()
        showAlert(withTitle: nil, andMessage: MyShop_Strings.PRODUCT_ADDED_SUCCESSFULLY)
    }
    
    @IBAction func changedColor() {
    }
    
    @IBAction func changedSize() {
    }
}
