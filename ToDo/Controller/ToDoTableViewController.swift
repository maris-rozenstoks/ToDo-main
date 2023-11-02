//
//  ToDoTableViewController.swift
//  ToDo
//
//  Created by Arkadijs Makarenko on 30/10/2023.
//

import UIKit
import CoreData

class ToDoTableViewController: UITableViewController {
    
    var managedObjectContext: NSManagedObjectContext?
    //    var toDos: [String] = []
    var toDoLists = [ToDo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        managedObjectContext = appDelegate.persistentContainer.viewContext
        loadCoreData()
        
        
        // Uncomment the following line to preserve selection between presentations
       self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    @IBAction func addNewItemTapped(_ sender: Any) {
        
        let alertController = UIAlertController(title: "To-Do List", message: "Do you want to add a new item?", preferredStyle: .alert)
        
        alertController.addTextField { textFieldValue in
            textFieldValue.placeholder = "Your title here..."
        }
        
        alertController.addTextField { textFieldValue in
            textFieldValue.placeholder = "Subtitle..."
        }
        
        let addActionButton = UIAlertAction(title: "Add", style: .default) { addActions in
            let titleTextField = alertController.textFields?.first
            let subtitleTextField = alertController.textFields?[1]
            
            let entity = NSEntityDescription.entity(forEntityName: "ToDo", in: self.managedObjectContext!)
            let list = NSManagedObject(entity: entity!, insertInto: self.managedObjectContext)
            
            list.setValue(titleTextField?.text, forKey: "item")
            list.setValue(subtitleTextField?.text, forKey: "subtitle")
            
            self.saveCoreData()
        }
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .destructive)
        
        alertController.addAction(addActionButton)
        alertController.addAction(cancelActionButton)
        
        present(alertController, animated: true)
    }
    
    @IBAction func deleteAllItemsTapped(_ sender: Any) {
        let deleteAllAlertController = UIAlertController(title: "Delete all?", message: "Are you sure you want to delete all items?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
            self.deleteAllCoreData()
        }
        
        let noAction = UIAlertAction(title: "No", style: .default, handler: nil)
        
        deleteAllAlertController.addAction(yesAction)
        deleteAllAlertController.addAction(noAction)
        
        present(deleteAllAlertController, animated: true)
    }

}




