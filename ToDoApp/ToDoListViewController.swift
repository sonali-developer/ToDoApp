//
//  ToDoListViewController.swift
//  ToDoApp
//
//  Created by Sonali Patel on 9/15/18.
//  Copyright © 2018 Sonali Patel. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    let itemArray = ["Finish Coding", "Eat food timely", "Take regular sleep", "Stay Healthy"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // MARK: - TableView Datasource Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    //MARK: - Table View delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print(itemArray[indexPath.row])
     tableView.deselectRow(at: indexPath, animated: true)
        if let selectedCell = tableView.cellForRow(at: indexPath) {
                if selectedCell.accessoryType == .none {
                    selectedCell.accessoryType = .checkmark
                } else {
                    selectedCell.accessoryType = .none
            }
        }
       
       
        
    }



}

