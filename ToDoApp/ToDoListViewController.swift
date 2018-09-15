//
//  ToDoListViewController.swift
//  ToDoApp
//
//  Created by Sonali Patel on 9/15/18.
//  Copyright © 2018 Sonali Patel. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
// Model Data
    var itemArray = ["Finish Coding", "Eat food timely", "Take regular sleep", "Stay Healthy"]
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        if let items = defaults.array(forKey: "ToDoListItemArray") as? [String] {
            itemArray = items
        }
        
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
    
    //MARK: - Add New Items in To Do List

  
    @IBAction func addItemButtonPressed(_ sender: UIBarButtonItem) {
        var resultantTextField = UITextField()
        let alert = UIAlertController(title: "Add New To Do Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen once the user clicks the Add Item Button on our UIAlert
            print("Add Button Pressed")
            print(resultantTextField.text!)
            self.itemArray.append(resultantTextField.text!)
            self.defaults.set(self.itemArray, forKey: "ToDoListItemArray")
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            resultantTextField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
}

}
