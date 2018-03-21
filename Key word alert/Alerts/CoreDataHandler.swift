//
//  CoreDataStack.swift
//  Key word alert
//
//  Created by Borui Zhou on 2018-03-13.
//  Copyright © 2018 Borui Zhou. All rights reserved.
//

import UIKit
import CoreData


class CoreDataHandler: NSObject{
    
    class func fetchKeyword() -> [Keyword]? {
        let context = CoreDataContainer.sharedInstance.persistentContainer.viewContext
        var keyword:[Keyword]? = nil
        do {
            keyword = try context.fetch(Keyword.fetchRequest())
            return keyword
        } catch  {
            return keyword
        }
    }
    class func fetchThreadInfo() -> [ThreadInfo]? {
        let context = CoreDataContainer.sharedInstance.persistentContainer.viewContext
        var threadInfo:[ThreadInfo]? = nil
        do {
            threadInfo = try context.fetch(ThreadInfo.fetchRequest())
            return threadInfo
        } catch  {
            return threadInfo
        }
    }
}




