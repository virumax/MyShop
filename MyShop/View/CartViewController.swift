//
//  CartViewController.swift
//  MyShop
//
//  Created by Virendra Ravalji on 2019/7/6.
//  Copyright © 2019 Virendra Ravalji. All rights reserved.
//

import UIKit

class CartViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var priceLabel: UILabel!
    
    var cartViewModel: CartViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set title
        self.navigationItem.title = cartViewModel?.titleText
        
        initViewModel()
        
        cartViewModel?.fetchAllProducts()
    }
    
    // MARK: UI Methods
    func initViewModel() {
        // Whenever products array updates reload the collection view
        cartViewModel?.productsDidChange = { [unowned self] viewModel in
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.priceLabel.text = self.cartViewModel?.totalPrice
            }
        }
    }
}

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartViewModel?.cartProducts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // get a reference to our storyboard cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        
        let product = cartViewModel?.cartProducts?[indexPath.item]
        let price: String?
        if let variant = product?.variant {
            let rupee = "\u{20B9}"
            price = rupee + " " + "\(variant.price)"
        } else {
            price = "Currently Unavailable"
        }
        
        let productNameLabel = cell.contentView.viewWithTag(1) as! UILabel
        let productPriceLabel = cell.contentView.viewWithTag(2) as! UILabel
        productNameLabel.text = product?.product?.name
        productPriceLabel.text = price
        
        return cell
    }
}
