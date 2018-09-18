//
//  ToDoListViewController.swift
//  ToDoApp
//
//  Created by Sonali Patel on 9/15/18.
//  Copyright © 2018 Sonali Patel. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {

    var toDoItems: Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if let category = selectedCategory {
            guard let navController = navigationController  else {
                print("Fatal Error, Navigation Controller is not available")
                return
            }
            searchBar.barTintColor = UIColor(hexString: category.backgroundColorString)
            let navBar = navController.navigationBar
            title = category.name
            if let navBarColor = UIColor(hexString: category.backgroundColorString) {
                let navBarContrastColor = ContrastColorOf(navBarColor, returnFlat: true)
                navBar.barTintColor =  navBarColor
                navBar.tintColor = navBarContrastColor
                navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: navBarContrastColor]
            } else {
                let color = UIColor.randomFlat
                navBar.barTintColor = color
                navBar.tintColor = ContrastColorOf(color, returnFlat: true)
            }
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let originalColor = UIColor(hexString: "04ABC5") else {
             print("Fatal error")
            return 
        }
        navigationController?.navigationBar.barTintColor = originalColor
        navigationController?.navigationBar.tintColor = FlatWhite()
    navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: FlatWhite()]
    }
    
    // MARK: - TableView Datasource Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            // Use of Ternary Operator
            
            cell.accessoryType = item.done ? .checkmark : .none
            if let items = toDoItems {
                if let color = UIColor(hexString: selectedCategory!.backgroundColorString)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(items.count)) {
                    cell.backgroundColor = color
                    cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
                } else {
                    let cellBgColor = UIColor.randomFlat
                    cell.backgroundColor = cellBgColor
                    cell.textLabel?.textColor = ContrastColorOf(cellBgColor, returnFlat: true)
                }
               
            }
            
        } else {
            cell.textLabel?.text = "No Items added yet"
            let color = UIColor.randomFlat
            cell.backgroundColor = color
            cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
        }
       
        return cell
    }
    
    //MARK: - Table View delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
//                    realm.delete(item)
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
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
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = resultantTextField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving data to Item object, \(error)")
                }
                
            }
            self.tableView.reloadData()

        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            resultantTextField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    //MARK: - Model Manipulation Methods
    
    
    func loadItems() {
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        

        tableView.reloadData()
    }
    
    //MARK: - Delete Data from Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        super.updateModel(at: indexPath)
        if let itemForDeletion = self.toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    self.realm.delete(itemForDeletion)
                }
            } catch {
                print("Error deleting item, \(error)")
            }
        }
    }
    

}
//MARK: - Search Bar Delegate Methods Implementation

extension ToDoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//         toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
//
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.predicate = predicate
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        print("Search bar's text = \(searchBar.text!)")
//
//        loadItems(with: request, predicate: predicate)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
}
