//
//  CategoryTableViewController.swift
//  ToDoApp
//
//  Created by Sonali Patel on 9/17/18.
//  Copyright © 2018 Sonali Patel. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController  {
    
    let realm = try! Realm()
    var categoryArray: Results<Category>?
    var indexpathFromSelectedRow: IndexPath = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
        loadCategories()
    }

   
    
    //MARK: - Table View Data Source Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = categoryArray?[indexPath.row] {
            cell.textLabel?.text = category.name
            guard let cellBackgroundColor = UIColor(hexString: category.backgroundColorString)  else {
                fatalError()
            }
            cell.backgroundColor = cellBackgroundColor
            cell.textLabel?.textColor = ContrastColorOf(cellBackgroundColor, returnFlat: true)
        } else {
            cell.textLabel?.text = "No Categories added yet"
            cell.backgroundColor = UIColor.randomFlat
        }
    
//        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories added yet"
//
//        if let bgColorHexValue = categoryArray?[indexPath.row].backgroundColorString {
//             cell.backgroundColor = UIColor(hexString: bgColorHexValue)
//        }
        
        return cell
        
    }
    
   
    
    
    //MARK: - Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexpathFromSelectedRow = indexPath
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as!  ToDoListViewController
//        let indexpath1 = tableView.indexPathForSelectedRow
//        print("indexpath1 \(indexpath1)")
        let indexPath1 = indexpathFromSelectedRow
            destinationVC.selectedCategory = categoryArray?[indexPath1.row]
    }
    
    
    //MARK: - Data Manipulation Methods
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context, \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    //MARK: - Delete Data from Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        super.updateModel(at: indexPath)
        if let categoryForDeletion = self.categoryArray?[indexPath.row] {
            do {
                try realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
    }
    
    //MARK: - Add New Category Button Pressed
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var catResultantTextField = UITextField()
        let alert = UIAlertController(title: "Add New To Do List Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            print(catResultantTextField.text!)
            let newCategory = Category()
            newCategory.name = catResultantTextField.text!
            newCategory.backgroundColorString = UIColor.randomFlat.hexValue()
            self.save(category: newCategory)
        }
        alert.addTextField { (categoryTextField) in
            categoryTextField.placeholder = "Enter New Category"
            catResultantTextField = categoryTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }

}


