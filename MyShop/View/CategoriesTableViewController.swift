//
//  MenuTableViewController.swift
//  MyShop
//
//  Created by Virendra Ravalji on 2019/7/2.
//  Copyright © 2019 Virendra Ravalji. All rights reserved.
//

import Foundation
import CollapsibleTableSectionViewController

class CategoriesViewController: CollapsibleTableSectionViewController {
    
    var categoryViewModel: CategoriesViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set title
        self.navigationItem.title = categoryViewModel?.titleText
        
        self.delegate = self as CollapsibleTableSectionDelegate
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: MyShop_Strings.CANCEL, style: .plain, target: self, action: #selector(dissmissView))
    }
    
    @objc func dissmissView(sender: UIBarButtonItem) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension CategoriesViewController: CollapsibleTableSectionDelegate {
    func numberOfSections(_ tableView: UITableView) -> Int {
        return categoryViewModel?.categoryMenu.count ?? 0
    }
    
    func collapsibleTableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryViewModel?.categoryMenu[section].subCategories.count ?? 0
    }
    
    func collapsibleTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell") as UITableViewCell? ?? UITableViewCell(style: .subtitle, reuseIdentifier: "BasicCell")
        
        if let subCategory: CategoriesEntity = categoryViewModel?.categoryMenu[indexPath.section].subCategories[indexPath.row] {
            cell.textLabel?.text = subCategory.name
        }
        
        return cell
    }
    
    func collapsibleTableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categoryViewModel?.categoryMenu[section].mainCategory.name
    }
    
    func collapsibleTableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let subCategory: CategoriesEntity = categoryViewModel?.categoryMenu[indexPath.section].subCategories[indexPath.row], let subCategories = subCategory.subCategories as? [Int],  subCategories.count > 0 {
            let categoriesMenu = CategoriesViewController()
            let newCategoryViewModel = CategoriesViewModel(categories: [subCategory], title: subCategory.name!)
            newCategoryViewModel.delegate = categoryViewModel?.delegate
            categoriesMenu.categoryViewModel = newCategoryViewModel
            self.navigationController?.pushViewController(categoriesMenu, animated: true)
        } else {
            if let subCategory: CategoriesEntity = categoryViewModel?.categoryMenu[indexPath.section].subCategories[indexPath.row] {
            self.navigationController?.dismiss(animated: true, completion: {[weak self] in
                self?.categoryViewModel?.delegate?.refreshHomeView(forCategory: subCategory)
            })
            } else {
                self.navigationController?.dismiss(animated: true, completion: nil)
            }
        }
    }
}
