//
//  CoreDataWithImagePickerViewModel.swift
//  SSODemo
//
//  Created by wfh on 09/01/19.
//  Copyright © 2019 Harsha. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataWithImagePickerViewModel: NSObject {
    
    var model: CoreDataWithImagePickerModel = CoreDataWithImagePickerModel()
    
    @discardableResult func saveImagesToDB(image : UIImage) -> Bool {
        let managedContext = SSODemoContextManager.sharedContextManager.mainManagedObjectContext
        if let entity = NSEntityDescription.entity(forEntityName: Constants.EntityNames.galleryImageEntity,in: managedContext) {
            let managedObject = NSManagedObject(entity: entity, insertInto: managedContext)
            if let data = image.pngData() {
                managedObject.setValue("ABC", forKey: "imageName")
                managedObject.setValue(data, forKey: "image")
                if model.addedImageArray == nil {
                    model.addedImageArray = [data]
                } else {
                    model.addedImageArray?.insert(data, at: 0)
                }
            }
        }
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
    }
    
    @discardableResult func fetchImagesFromDB() -> Bool {
        let managedContext = SSODemoContextManager.sharedContextManager.mainManagedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.EntityNames.galleryImageEntity)
        
        do {
            let result =  try managedContext.fetch(fetchRequest)
            if result.count > 0 {
                model.fetchedImageArray = result.reversed() as [AnyObject]
                return true
            }
            return false
        } catch let error as NSError {
            print("Error \(error)")
            return false
        }
    }
    
}
