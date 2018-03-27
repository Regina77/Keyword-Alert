//
//  CoreDataContainer.swift
//  Key word alert
//
//  Created by Borui Zhou on 2018-03-14.
//  Copyright © 2018 Borui Zhou. All rights reserved.
//

import Foundation
import CoreData


class CoreDataContainer {
    
    static let sharedInstance : CoreDataContainer = CoreDataContainer.init()
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Keywords")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func loadItems () {
        let context = persistentContainer.viewContext
        let request : NSFetchRequest<ThreadInfo> = ThreadInfo.fetchRequest()
        do {
            try context.fetch(request)
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
}



