//
//  MenuViewController.swift
//  StoreSearch
//
//  Created by DANIEL DE VERE on 2/5/17.
//  Copyright (c) 2017 DANIEL DE VERE. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {
    
    weak var delegate: MenuViewControllerDelegate?
    
        override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            delegate?.menuViewControllerSendSupportEmail(self)
        } else if indexPath.row == 3 {
            delegate?.cancelEmailMenu()
        }
        
    }
    
    
}

protocol MenuViewControllerDelegate: class {
    func menuViewControllerSendSupportEmail(MenuViewController)
    func cancelEmailMenu()
}