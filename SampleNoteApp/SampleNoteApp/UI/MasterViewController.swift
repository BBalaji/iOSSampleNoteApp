//
//  MasterViewController.swift
//  SampleNoteApp
//
//  Created by Besta, Balaji (623-Extern) on 04/02/20.
//  Copyright © 2020 Balaji Besta. All rights reserved.
//

import UIKit
import CoreData

enum Sort: String {
    case Date = "noteTimeStamp"
    case Title = "noteTitle"
    case Text = "noteText"
}
class MasterViewController: UITableViewController, UISearchResultsUpdating {

    var detailViewController: DetailViewController? = nil
    let searchController = UISearchController(searchResultsController: nil)


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = searchController.searchBar
        
        
        // Core data initialization
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            // create alert
            let alert = UIAlertController(
                title: "Could note get app delegate",
                message: "Could note get app delegate, unexpected error occurred. Try again later.",
                preferredStyle: .alert)
            
            // add OK action
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .default))
            // show alert
            self.present(alert, animated: true)

            return
        }
        
        // As we know that container is set up in the AppDelegates so we need to refer that container.
        // We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // set context in the storage
        SampleNoteStorage.storage.setManagedContext(managedObjectContext: managedContext)
        
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        let organizeButton = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(organizeObjects(_:)))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
//        navigationItem.rightBarButtonItem = addButton
        navigationItem.rightBarButtonItems = [addButton,space,organizeButton]
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        searchController.searchBar.endEditing(true)
        searchController.searchBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
//        searchController.searchBar.endEditing(true)
        searchController.searchBar.isHidden = false
    }

    
    @objc
    func insertNewObject(_ sender: Any) {
        performSegue(withIdentifier: "showCreateNoteSegue", sender: self)
    }
    
    @objc
    func organizeObjects(_ sender: Any) {
//        performSegue(withIdentifier: "showCreateNoteSegue", sender: self)
        print("organizing records")
        
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            // create alert
            let alert = UIAlertController(
                title: "Could note get app delegate",
                message: "Could note get app delegate, unexpected error occurred. Try again later.",
                preferredStyle: .alert)
            
            // add OK action
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .default))
            // show alert
            self.present(alert, animated: true)

            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let alertController = UIAlertController(title: nil, message: "Alert message.", preferredStyle: .actionSheet)

        let defaultAction = UIAlertAction(title: "Default (Date Edited)", style: .default, handler: { (alert: UIAlertAction!) -> Void in
          //  Do some action here.
            SampleNoteStorage.storage.setManagedContext(managedObjectContext: managedContext,sortBy: Sort.Date.rawValue,ASC: false)
            self.tableView.reloadData()
        })
        let DateEditedAction = UIAlertAction(title: "Date Edited", style: .default, handler: { (alert: UIAlertAction!) -> Void in
          //  Do some action here.
            SampleNoteStorage.storage.setManagedContext(managedObjectContext: managedContext,sortBy: Sort.Date.rawValue,ASC: false)
            self.tableView.reloadData()
        })

        let titleAction = UIAlertAction(title: "Title", style: .default, handler: { (alert: UIAlertAction!) -> Void in
          //  Do some destructive action here.
            SampleNoteStorage.storage.setManagedContext(managedObjectContext: managedContext,sortBy: Sort.Title.rawValue,ASC: true)
            self.tableView.reloadData()
        })
        
        let descriptionAction = UIAlertAction(title: "Description", style: .default, handler: { (alert: UIAlertAction!) -> Void in
          //  Do some destructive action here.
            SampleNoteStorage.storage.setManagedContext(managedObjectContext: managedContext,sortBy: Sort.Text.rawValue,ASC: true)
            self.tableView.reloadData()
        })


        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction!) -> Void in
          //  Do something here upon cancellation.
        })

        alertController.addAction(defaultAction)
        alertController.addAction(DateEditedAction)
        alertController.addAction(titleAction)
        alertController.addAction(descriptionAction)
        alertController.addAction(cancelAction)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.barButtonItem = sender as? UIBarButtonItem
        }
        

        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText : String = searchController.searchBar.text!
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            // create alert
            let alert = UIAlertController(
                title: "Could note get app delegate",
                message: "Could note get app delegate, unexpected error occurred. Try again later.",
                preferredStyle: .alert)
            
            // add OK action
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .default))
            // show alert
            self.present(alert, animated: true)

            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        if searchText.count > 0 {
        print("Before Search Count :: ",SampleNoteStorage.storage.count())

        // set context in the storage
        SampleNoteStorage.storage.setManagedContext(managedObjectContext: managedContext,searchText: searchText)
        print("After Search Count :: ",SampleNoteStorage.storage.count())
        self.tableView.reloadData()
        }
        else{
            SampleNoteStorage.storage.setManagedContext(managedObjectContext: managedContext)
            self.tableView.reloadData()
        }

    }
    
    
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                self.view.endEditing(true)
                //let object = objects[indexPath.row]
                let object = SampleNoteStorage.storage.readNote(at: indexPath.row)
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return objects.count
        return SampleNoteStorage.storage.count()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SampleNoteUITableViewCell

        if let object = SampleNoteStorage.storage.readNote(at: indexPath.row) {
        cell.noteTitleLabel!.text = object.noteTitle
        cell.noteTextLabel!.text = object.noteText
            cell.noteDateLabel!.text = SampleNoteDateHelper.convertDate(date: Date.init(seconds: object.noteTimeStamp))
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //objects.remove(at: indexPath.row)
            SampleNoteStorage.storage.removeNote(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}


