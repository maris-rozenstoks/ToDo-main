//
//  Extension.swift
//  ToDo
//
//  Created by maris.rozenstoks on 02/11/2023.
//

import UIKit
import Foundation
import CoreData

// MARK: - CoreData logic
extension ToDoTableViewController {
    func loadCoreData(){
        
        let request: NSFetchRequest<ToDo> = ToDo.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]

        
        do {
            let result = try managedObjectContext?.fetch(request)
            toDoLists = result ?? []
            self.tableView.reloadData()
        } catch {
            fatalError("Error in loading item into core data")
        }
    }
    
    
    func saveCoreData(){
        do {
            try managedObjectContext?.save()
        } catch {
            fatalError("Error in saving item into core data")
        }
        loadCoreData()
    }
    
    func deleteAllCoreData() {
        let fetchRequest: NSFetchRequest<ToDo> = ToDo.fetchRequest()
        
        if let results = try? managedObjectContext?.fetch(fetchRequest) {
            for object in results {
                managedObjectContext?.delete(object)
            }
            
            saveCoreData()
        }
    }
    
#warning("delete All CoreData")
    
    
}

// MARK: - Table view data source
extension ToDoTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return toDoLists.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath)
        
        let toDoList = toDoLists[indexPath.row]
        cell.textLabel?.text = toDoList.item
        cell.detailTextLabel?.text = toDoList.subtitle
        cell.accessoryType = toDoList.completed ? .checkmark : .none
        
        if toDoList.completed {
            if traitCollection.userInterfaceStyle == .dark {
                cell.textLabel?.textColor = UIColor.gray
                cell.detailTextLabel?.textColor = UIColor.gray
            } else {
                cell.textLabel?.textColor = UIColor.gray
                cell.detailTextLabel?.textColor = UIColor.gray
            }
        } else {
            cell.textLabel?.textColor = UIColor.label
            cell.detailTextLabel?.textColor = UIColor.secondaryLabel
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        toDoLists[indexPath.row].completed = !toDoLists[indexPath.row].completed
        saveCoreData()
    }
    
    
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            managedObjectContext?.delete(toDoLists[indexPath.row])
        }
        saveCoreData()
    }
    
    
   
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
     let movedItem = toDoLists.remove(at: sourceIndexPath.row)
     toDoLists.insert(movedItem, at: destinationIndexPath.row)
     
     // Update the "order" attribute based on the new order
     for (index, toDo) in toDoLists.enumerated() {
     toDo.order = Int16(index)
     }
     
     saveCoreData()
     }
    
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}

