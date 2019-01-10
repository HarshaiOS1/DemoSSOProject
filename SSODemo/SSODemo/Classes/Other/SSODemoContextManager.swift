//
//  SSODemoContextManager.swift
//  SSODemo
//
//  Created by wfh on 09/01/19.
//  Copyright © 2019 Harsha. All rights reserved.
//

import Foundation
import CoreData
import NotificationCenter

class SSODemoContextManager: NSObject {
    private override init() { }
    
    static let sharedContextManager:SSODemoContextManager = {
        let contextManager = SSODemoContextManager()
        let persistant = contextManager.persistentContainer
        return contextManager
    }()
    
    // MARK: Core Data stack
    lazy var mainManagedObjectContext: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()
    
    lazy var privateManagedObjectContext: NSManagedObjectContext = {
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentContainer.persistentStoreCoordinator
        managedObjectContext.mergePolicy = NSMergePolicy(merge: NSMergePolicyType.mergeByPropertyObjectTrumpMergePolicyType)
        return managedObjectContext
    }()
    
    @objc func saveChanges(_ notification: NSNotification) {
        let mainManagedObjectContext = self.mainManagedObjectContext
        if let privateManagedObjectContext = notification.object as? NSManagedObjectContext {
            mainManagedObjectContext.perform {
                do {
                    if mainManagedObjectContext.hasChanges {
                        try mainManagedObjectContext.save()
                    }
                } catch {
                    NSLog("Unable to save changes in main managed object context \n", error as NSError)
                }
                
                if mainManagedObjectContext != privateManagedObjectContext {
                    privateManagedObjectContext.perform {
                        do {
                            if privateManagedObjectContext.hasChanges {
                                try privateManagedObjectContext.save()
                            }
                        } catch {
                            NSLog("Unable to save changes in private managed object context \n", error as NSError)
                        }
                    }
                }
            }
        }
    }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SSODemoDataModel")
        container.viewContext.mergePolicy = NSMergePolicy(merge: NSMergePolicyType.mergeByPropertyObjectTrumpMergePolicyType)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            NSLog("Persistent store description  - \(storeDescription)")
            storeDescription.shouldInferMappingModelAutomatically = true
            storeDescription.shouldMigrateStoreAutomatically = true
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}

//MARK: AppState Notification Observers
extension SSODemoContextManager {
    func setupSaveChangesNotification() {
        let context  = persistentContainer.viewContext
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.saveChanges(_:)), name: UIApplication.willTerminateNotification, object: context)
        notificationCenter.addObserver(self, selector: #selector(self.saveChanges(_:)), name: UIApplication.willResignActiveNotification, object: context)
        notificationCenter.addObserver(self, selector: #selector(self.saveChanges(_:)), name: Notification.Name.NSManagedObjectContextDidSave, object: context)
    }
}
