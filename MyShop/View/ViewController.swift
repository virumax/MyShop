//
//  ViewController.swift
//  MyShop
//
//  Created by Virendra Ravalji on 2019/7/1.
//  Copyright © 2019 Virendra Ravalji. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // View model instance
    lazy var viewModel: HomeViewModelProtocol = {
        HomeViewModel(apiService: APIService())
    }()
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViewModel()
        
        // Fetch data from DB
        viewModel.fetchData()
        
        // Set title
        self.navigationItem.title = viewModel.titleText
        
        let filterButton = UIBarButtonItem(title: "Filter", style: .done, target: self, action: #selector(showFilterMenu))
        let rankingButton = UIBarButtonItem(title: "Rankings", style: .done, target: self, action: #selector(showRankingMenu))
        self.navigationItem.rightBarButtonItems = [rankingButton, filterButton]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Categories", style: .done, target: self, action: #selector(showCategories))
    }
    
    func initViewModel() {
        // Whenever products array updates reload the collection view
        viewModel.productsDidChange = { [unowned self] viewModel in
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    @objc func showCategories() {
        viewModel.getCategories { (categories) in
            if let categories = categories {
                let categoriesMenu = MenuTableViewController()
                let categoriesViewModel = CategoriesViewModel(categories: categories, title: "Categories")
                categoriesViewModel.delegate = viewModel as? RefreshHomeViewProtocol
                categoriesMenu.categoryViewModel = categoriesViewModel
                let navigationController = UINavigationController.init(rootViewController: categoriesMenu)
                self.navigationController?.present(navigationController, animated: true, completion: nil)
            }
        }
    }
    
    @objc func showFilterMenu() {
        let alert = UIAlertController(title: "Variants", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "By Color", style: .default , handler:{ (UIAlertAction)in
            print("User click \(String(describing: UIAlertAction.title)) button")
            
        }))
        
        alert.addAction(UIAlertAction(title: "By Size", style: .default , handler:{ (UIAlertAction)in
            print("User click \(String(describing: UIAlertAction.title)) button")
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click \(String(describing: UIAlertAction.title)) button")
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func showRankingMenu() {
        viewModel.getRankings { (rankings) in
            if let rankings = rankings, rankings.count > 0 {
                let alert = UIAlertController(title: "Rankings", message: "Please Select an Option", preferredStyle: .actionSheet)
                
                for ranking in rankings {
                    alert.addAction(UIAlertAction(title: ranking.name, style: .default , handler:{ (UIAlertAction)in
                        print("User click \(String(describing: UIAlertAction.title)) button")
                    }))
                }
                
                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
                    print("User click Dismiss button")
                }))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.products?.count ?? 0
    }
    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return ((viewModel.products?.count ?? 0) > 0 ? 2 : 0)
//    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! ProductCollectionViewCell
        
        let product = viewModel.products?[indexPath.item]
        
        cell.productImage.backgroundColor = .red

        if let variants = product?.variants {
            let rupee = "\u{20B9}"
            let arrayOfVariants = Array(variants) as! Array<VariantEntity>
            cell.priceLabel.text = rupee + " " + "\(arrayOfVariants[0].price)"
        } else {
            cell.priceLabel.text = "Currently Unavailable"
        }
        
        cell.descriptionLabel.text = product?.name
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected item is \(indexPath.item)")
    }
}

// Extenstion to determine the size of collection view cell
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.size.width - 15 * 2) / 2 //some width
        let height = width * 1.6 //ratio
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
    }
}
