
//
//  KeywordTableViewController.swift
//  Key word alert
//
//  Created by Borui Zhou on 2018-03-07.
//  Copyright © 2018 Borui Zhou. All rights reserved.
//

import UIKit
import CoreData

class KeywordTableViewController: UITableViewController {
    
    // MARK : - Properties
    
    var resultsController: NSFetchedResultsController<Keyword>!
    let coreDataStack = CoreDataStack()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Request
        let request: NSFetchRequest<Keyword> = Keyword.fetchRequest()
        let sortDescriptors = NSSortDescriptor(key: "keyword", ascending: true)
        
        // Init
        request.sortDescriptors = [sortDescriptors]
        resultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: coreDataStack.managedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        resultsController.delegate = self
        // Fetch
        do {
            try resultsController.performFetch()
        } catch {
            print("Perform fatal error: \(error)")
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return resultsController.sections?[section].numberOfObjects ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "keywordCell", for: indexPath)

        // Configure the cell...
        let keyword = resultsController.object(at: indexPath)
        cell.textLabel?.text = keyword.keyword

        return cell
    }
    
    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let leftSwipe = UIContextualAction(style: .destructive, title: "Delete") { (leftSwipe, view, completion) in
            // delete keyword
            let keyword = self.resultsController.object(at: indexPath)
            self.resultsController.managedObjectContext.delete(keyword)
            do{
                try self.resultsController.managedObjectContext.save()
                completion(true)
            } catch {
                print("delete failed: \(error)")
                completion(false)
            }
            
        }
       // leftSwipe.image = delete
        leftSwipe.backgroundColor = .red
        //leftSwipe.image = UIImage.init(named: delete)
        return UISwipeActionsConfiguration(actions: [leftSwipe])
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let _ = sender as? UIBarButtonItem, let vc = segue.destination as? AddKeywordViewController{
            vc.managedContext = resultsController.managedObjectContext
        }
        
    }


}

extension KeywordTableViewController: NSFetchedResultsControllerDelegate{
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath{
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath{
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        default:
            break
        }
    }
}

