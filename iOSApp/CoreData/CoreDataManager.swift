//
//  CoreDataManager.swift
//  NACTA-Tatheer
//
//  Created by Asim Parvez on 12/14/17.
//  Copyright © 2017 Asim Parvez. All rights reserved.
//

import Foundation

//
//  DataManager.swift
//  NACTA-Tatheer
//
//  Created by Asim Parvez on 11/20/17.
//  Copyright © 2017 Asim Parvez. All rights reserved.
//

import UIKit
import CoreData




class CoreDataManager: NSObject {
    
    //MARK: - Instance/Class Variables
    static let shared : CoreDataManager = CoreDataManager()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context : NSManagedObjectContext!
    
    //MARK: - Initializers
    private override init() {
        context = appDelegate.persistentContainer.viewContext
    }
    
    
    //MARK: - Save Current Context
    func saveCurrentContext() {
        do {
            try self.context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    
    //MARK: - FetchRecords Cached
    func fetchAllRecords(entity: String) -> [NSManagedObject]? {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            
            let fetchedObjs = result as? [NSManagedObject]
            return fetchedObjs
            
        } catch {
            
            print("Failed")
            return nil
        }
        
    }
    
    //MARK: - Delete All Records For Entity
    func deleteAllRecordsFor(entity: String) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)

        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            
        } catch {
            // Error Handling
        }
    }
    
}

