//
//  ViewController.swift
//  MyShop
//
//  Created by Virendra Ravalji on 2019/7/1.
//  Copyright © 2019 Virendra Ravalji. All rights reserved.
//

import UIKit
import SideMenu
import MBProgressHUD

protocol SideMenuProtocol: class {
    func sideMenuSelected(item: MenuItem?)
}

enum MenuItem: String {
    case categories = "Search by Categories"
    case filter = "Apply Filter"
    case rankings = "Search by Rankings"
}

class HomeViewController: UIViewController, SideMenuProtocol {

    // View model instance
    lazy var viewModel: HomeViewModelProtocol = {
        HomeViewModel(apiService: APIService())
    }()
    var filterPickerView = UIPickerView()
    var toolBar = UIToolbar()
    var pickerData = [String]()
    lazy var searchBar = UISearchBar(frame: CGRect.zero)
    
    // IB Properties
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backgroundMessage: UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViewModel()
        
        // Fetch data from DB
        reloadData()
        
        // Setup navigation bar
        setupNavigationBar()
    }
    
    // MARK: UI Methods
    func initViewModel() {
        // Whenever products array updates reload the collection view
        viewModel.productsDidChange = { [unowned self] viewModel in
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                if viewModel.products?.count == 0 {
                    self.backgroundMessage.text = "Sorry, no more products to display"
                } else {
                    self.backgroundMessage.text = ""
                }
                
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
        
        // Whenever internet connetion changes
        viewModel.alertMessageDidChange =  { [unowned self] viewModel in
            DispatchQueue.main.async {
                self.showAlert(withTitle: "Error", andMessage: viewModel.alertMessage)
                self.backgroundMessage.text = viewModel.alertMessage
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
    }
    
    func setupNavigationBar() {
        // Set title
        self.navigationItem.title = viewModel.titleText
        
        let reloadButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 50))
        reloadButton.setImage(UIImage(named: "reload"), for: .normal)
        reloadButton.imageEdgeInsets = UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8);
        reloadButton.addTarget(self, action: #selector(reloadData), for: .touchUpInside)
        
        let searchButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 50))
        searchButton.setImage(UIImage(named: "search"), for: .normal)
        searchButton.imageEdgeInsets = UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8);
        searchButton.addTarget(self, action: #selector(searchProducts), for: .touchUpInside)
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: searchButton), UIBarButtonItem(customView: reloadButton)]
        
        let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 50))
        menuButton.setImage(UIImage(named: "menu"), for: .normal)
        menuButton.imageEdgeInsets = UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8);
        menuButton.addTarget(self, action: #selector(showSideMenu), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
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
    
    func showAlert(withTitle: String?, andMessage: String?) {
        let alert = UIAlertController(title: withTitle, message: andMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Action Methods
    @objc func showSideMenu() {
        let menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "menuView") as! UISideMenuNavigationController
        let sideMenuTableViewController = menuLeftNavigationController.topViewController as! SideMenuTableViewController
        sideMenuTableViewController.delegate = self
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        
        // (Optional) Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the view controller it displays!
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view, forMenu: .left)
        
        // (Optional) Prevent status bar area from turning black when menu appears:
        SideMenuManager.default.menuFadeStatusBar = false
        
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @objc func showCategories() {
        viewModel.getCategories { (categories) in
            if let categories = categories {
                let categoriesMenu = CategoriesViewController()
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
                if let variants = variants, variants.count > 0 {
                    for variant in variants {
                        if let color = variant.color, !(self?.pickerData.contains(color))! {
                            self?.pickerData.append(color)
                        }
                    }
                    if let count = self?.pickerData.count, count > 0 {
                        self?.addPickerView()
                    } else {
                        self?.showAlert(withTitle: nil, andMessage: "Color filter can't be applied to these products.")
                    }
                    self?.filterPickerView.tag = FilterType.color.getTag()
                }
            })
        }))
        
        alert.addAction(UIAlertAction(title: "By Size", style: .default , handler:{[weak self] (UIAlertAction)in
            self?.viewModel.getVariants(completionHandler: { (variants) in
                if let variants = variants, variants.count > 0 {
                    for variant in variants {
                        if variant.size != 0, !(self?.pickerData.contains(String(variant.size)))! {
                            self?.pickerData.append(String(variant.size))
                        }
                    }
                    if let count = self?.pickerData.count, count > 0 {
                        self?.addPickerView()
                    } else {
                        self?.showAlert(withTitle: nil, andMessage: "Size filter can't be applied to these products.")
                    }
                    self?.filterPickerView.tag = FilterType.size.getTag()
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
    
    @objc func searchProducts() {
        searchBar.placeholder = "Enter product name"
        searchBar.delegate = self
        UIView.animate(withDuration: 2) {[weak self] in
            self?.navigationItem.titleView = self?.searchBar
            
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(self?.cancelSearch))
            self?.navigationItem.rightBarButtonItems = [cancelButton]
            self?.navigationItem.leftBarButtonItem = nil
        }
        viewModel.backupPoductsList()
    }
    
    @objc func cancelSearch() {
        navigationItem.titleView = nil
        setupNavigationBar()
        viewModel.cancelSearch()
    }
    
    @objc func reloadData() {
        MBProgressHUD.showAdded(to: view, animated: true)
        viewModel.fetchData()
    }
    
    // MARK: PickerView action methods
    @objc func pickerViewDoneClick() {
        if viewModel.selectedPickerRow > 0 {
            if filterPickerView.tag == FilterType.color.getTag() {
                var colorFilters = viewModel.currentFilters[.color]
                if colorFilters == nil {
                    colorFilters = [String]()
                }
                if !colorFilters!.contains(pickerData[viewModel.selectedPickerRow]) {
                    colorFilters?.append(pickerData[viewModel.selectedPickerRow])
                }
                viewModel.currentFilters[.color] = colorFilters
            } else {
                var sizeFilters = viewModel.currentFilters[.size]
                if sizeFilters == nil {
                    sizeFilters = [String]()
                }
                if !sizeFilters!.contains(pickerData[viewModel.selectedPickerRow]) {
                    sizeFilters?.append(pickerData[viewModel.selectedPickerRow])
                }
                sizeFilters?.append(pickerData[viewModel.selectedPickerRow])
                viewModel.currentFilters[.size] = sizeFilters
            }
            viewModel.filterProducts()
        }
        viewModel.selectedPickerRow = -1
        filterPickerView.removeFromSuperview()
        toolBar.removeFromSuperview()
        pickerData.removeAll()
    }
    
    @objc func pickerViewCancelClick() {
        viewModel.selectedPickerRow = -1
        filterPickerView.removeFromSuperview()
        toolBar.removeFromSuperview()
        pickerData.removeAll()
    }
    
    //MARK: SideMenu delegate methods
    func sideMenuSelected(item: MenuItem?) {
        if let item = item {
            switch item {
            case .categories: showCategories()
            case .filter: showFilterMenu()
            case .rankings: showRankingMenu()
            }
        }
    }
}

// MARK: UICollectionView Delegate and DataSource
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.products?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! ProductCollectionViewCell
        
        let product = viewModel.products?[indexPath.item]
        
        cell.productImage.backgroundColor = .lightGray

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
        if let product = viewModel.products?[indexPath.item] {
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            let productDetailsView = storyBoard.instantiateViewController(withIdentifier: "ProductDetails") as! ProductDetailViewController
            let productDetailsViewModel = ProductDetailsViewModel(product: product, title: product.name!)
            productDetailsView.productDetailsViewModel = productDetailsViewModel
            self.navigationController?.pushViewController(productDetailsView, animated: true)
        }
    }
}

//MARK: Determine the size of collection view cell
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.size.width - 15 * 2) / 2 //some width
        let height = width * 1.6 //ratio
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
    }
}

//MARK: pickerview delegate & datasource
extension HomeViewController: UIPickerViewDataSource, UIPickerViewDelegate {
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
        viewModel.selectedPickerRow = row
    }
}

//MARK: UISearchBar delegate
extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterBySearchTerm(searchText: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.filterBySearchTerm(searchText: searchBar.text)
    }
}