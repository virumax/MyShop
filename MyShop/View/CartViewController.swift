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
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: MyShop_Strings.CHECKOUT, style: .plain, target: self, action: #selector(checkout))
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
    
    // MARK: Action methods
    @objc func checkout() {
        cartViewModel?.checkout()
        showAlert(withTitle: MyShop_Strings.SUCCESS, andMessage: MyShop_Strings.ORDER_PLACED)
    }
    
    func showAlert(withTitle: String?, andMessage: String?) {
        let alert = UIAlertController(title: withTitle, message: andMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: MyShop_Strings.OK, style: .default) { [weak self](_) in
            self?.navigationController?.popToRootViewController(animated: true)
        }
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
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
            price = MyShop_Strings.NOT_AVAILABLE
        }
        
        let productNameLabel = cell.contentView.viewWithTag(1) as! UILabel
        let productPriceLabel = cell.contentView.viewWithTag(2) as! UILabel
        productNameLabel.text = product?.product?.name
        productPriceLabel.text = price
        
        return cell
    }
}
