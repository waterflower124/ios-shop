//
//  MenuTableViewController.swift
//  FishDay
//
//  Created by Anas Sherif on 2/20/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
    
    var menuList = [Menu]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuList.append(Menu(name: "One", imageName: ""))
        menuList.append(Menu(name: "TWo", imageName: "fish"))
        menuList.append(Menu(name: "Three", imageName: "fish"))
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuTableViewCell
        let menu = menuList[indexPath.row]
        cell.menu = menu
        return cell
    }
    
}
