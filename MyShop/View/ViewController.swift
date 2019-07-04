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
    var filterPickerView = UIPickerView()
    var toolBar = UIToolbar()
    var pickerData = [String]()
        
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
    
    func addPickerView() {
        // UIPickerView
        filterPickerView = UIPickerView(frame:CGRect(x: 0, y: view.frame.size.height - 260, width: self.view.frame.size.width, height: 260))
        filterPickerView.delegate = self
        filterPickerView.dataSource = self
        filterPickerView.backgroundColor = UIColor.white
        view.addSubview(filterPickerView)
        
        // ToolBar
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 40))
        view.addSubview(toolBar)
        toolBar.barStyle = .default
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(pickerViewDoneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(pickerViewCancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
    }
    
    @objc func pickerViewDoneClick() {
        filterPickerView.removeFromSuperview()
        toolBar.removeFromSuperview()
        pickerData.removeAll()
    }
    
    @objc func pickerViewCancelClick() {
        filterPickerView.removeFromSuperview()
        toolBar.removeFromSuperview()
        pickerData.removeAll()
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
        
        alert.addAction(UIAlertAction(title: "By Color", style: .default , handler:{[weak self] (UIAlertAction)in
            self?.viewModel.getVariants(completionHandler: { (variants) in
                if let variants = variants {
                    for variant in variants {
                        if let color = variant.color, !(self?.pickerData.contains(color))! {
                            self?.pickerData.append(color)
                        }
                    }
                    self?.addPickerView()
                }
            })
        }))
        
        alert.addAction(UIAlertAction(title: "By Size", style: .default , handler:{[weak self] (UIAlertAction)in
            self?.viewModel.getVariants(completionHandler: { (variants) in
                if let variants = variants {
                    for variant in variants {
                        if variant.size != 0, !(self?.pickerData.contains(String(variant.size)))! {
                            self?.pickerData.append(String(variant.size))
                        }
                    }
                    self?.addPickerView()
                }
            })
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
                    alert.addAction(UIAlertAction(title: ranking.name, style: .default , handler:{[weak self] (UIAlertAction)in
                        self?.viewModel.getProductsForRanking(name: UIAlertAction.title!)
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

// Extension for pickerview delegate & datasource
extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(pickerData[row])
    }
}
