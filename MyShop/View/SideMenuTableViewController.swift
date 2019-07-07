//
//  SideMenuTableViewController.swift
//  MyShop
//
//  Created by Virendra Ravalji on 2019/7/6.
//  Copyright © 2019 Virendra Ravalji. All rights reserved.
//

import UIKit

class SideMenuTableViewController: UITableViewController {

    weak var delegate: SideMenuProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath)

        switch indexPath.row  {
        case 0: cell.textLabel?.text = MenuItem.categories.rawValue
        case 1: cell.textLabel?.text = MenuItem.filter.rawValue
        case 2: cell.textLabel?.text = MenuItem.rankings.rawValue
        default: break
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true, completion: {[weak self] in
            let item: MenuItem?
            switch indexPath.row  {
            case 0: item = .categories
            case 1: item = .filter
            case 2: item = .rankings
            default: item = nil
            }
            self?.delegate?.sideMenuSelected(item: item)
        })
    }
}
