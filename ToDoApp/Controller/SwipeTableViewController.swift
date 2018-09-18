//
//  SwipeTableViewController.swift
//  ToDoApp
//
//  Created by Sonali Patel on 9/18/18.
//  Copyright © 2018 Sonali Patel. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    //MARK: - Table View Edit Action Delegate Methods
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // Handle action by updating model with deletion
            
            self.updateModel(at: indexPath)
            print("Delete cell")
        }
        
        deleteAction.image = UIImage(named: "delete-icon")
        return [deleteAction]
    }
    
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    func updateModel(at indexPath: IndexPath) {
        // Update our data Model
    }
    
    //MARK: - Table View Data Source Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    


}
