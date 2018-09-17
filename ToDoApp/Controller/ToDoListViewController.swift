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
//    var itemArray = ["Finish Coding", "Eat food timely", "Take regular sleep", "Stay Healthy"]
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem1 = Item()
        newItem1.title = "Study Swift and iOS programming"
        itemArray.append(newItem1)
        
        let newItem2 = Item()
        newItem2.title = "Study InterviewCake Data Structures and Algorithm"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Refer resume and other topics"
        itemArray.append(newItem3)
        
        if let items = defaults.array(forKey: "ToDoListItemArray") as? [Item] {
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
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        // Use of Ternary Operator
        
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
    //MARK: - Table View delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print(itemArray[indexPath.row])
     tableView.deselectRow(at: indexPath, animated: true)
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.reloadData()
    
    }
    
    //MARK: - Add New Items in To Do List

  
    @IBAction func addItemButtonPressed(_ sender: UIBarButtonItem) {
        var resultantTextField = UITextField()
        let alert = UIAlertController(title: "Add New To Do Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen once the user clicks the Add Item Button on our UIAlert
            print("Add Button Pressed")
            print(resultantTextField.text!)
            
            let newItem = Item()
            newItem.title = resultantTextField.text!
            self.itemArray.append(newItem)
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
