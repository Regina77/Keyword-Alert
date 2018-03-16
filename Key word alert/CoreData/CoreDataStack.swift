//
//  CoreDataStack.swift
//  Key word alert
//
//  Created by Borui Zhou on 2018-03-08.
//  Copyright © 2018 Borui Zhou. All rights reserved.
//

import Foundation
import CoreData



class CoreDataStack {
    var container: NSPersistentContainer{
        let container = NSPersistentContainer(name: "Keywords")
        container.loadPersistentStores { (description, error) in
            guard error == nil else{
                print("Error: \(error!)")
                return
            }
        }
        return container
    }
    
    var managedContext: NSManagedObjectContext{
        return container.viewContext
    }
    
}


