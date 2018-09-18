//
//  CategoryTableViewController.swift
//  ToDoApp
//
//  Created by Sonali Patel on 9/17/18.
//  Copyright © 2018 Sonali Patel. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var categoryArray = [Category]()
    var indexpathFromSelectedRow: IndexPath = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }

   
    
    //MARK: - Table View Data Source Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
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
            destinationVC.selectedCategory = categoryArray[indexPath1.row]
    }
    
    
    //MARK: - Data Manipulation Methods
    
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray =  try context.fetch(request)
        } catch {
            print("Error fetching data from context, \(error)")
        }
        tableView.reloadData()
    }
    
    //MARK: - Add New Category Button Pressed
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var catResultantTextField = UITextField()
        let alert = UIAlertController(title: "Add New To Do List Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            print(catResultantTextField.text!)
            let newCategory = Category(context: self.context)
            newCategory.name = catResultantTextField.text!
            self.categoryArray.append(newCategory)
            self.saveCategories()            
        }
        alert.addTextField { (categoryTextField) in
            categoryTextField.placeholder = "Enter New Category"
            catResultantTextField = categoryTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }

}
