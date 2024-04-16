//
//  CoreDataManager.swift
//  YeggrrrWishListApp
//
//  Created by YJ on 4/15/24.
//

import UIKit
import CoreData

class CoreDataManager {
    static func fetch() -> [Product] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let managedContext = appDelegate.persistentContainer.viewContext
        let request = Product.fetchRequest()
        
        if let productList = try? managedContext.fetch(request) {
           return productList
        }
        
        return []
    }
    
    static func save(currentProduct: RemoteProduct?) {
        guard let currentProduct else { return }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let wishListProduct = Product(context: managedContext)
        
        wishListProduct.primaryKey = UUID()
        wishListProduct.id = Int64(currentProduct.id)
        wishListProduct.title = currentProduct.title
        wishListProduct.price = currentProduct.price
        
        do {
            try managedContext.save()
        } catch let myError {
            print(myError)
        }
    }
    
    static func delete(primaryKey: UUID?) {
        guard let primaryKey else { return }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Product")
        fetchRequest.predicate = NSPredicate(format: "primaryKey = %@", primaryKey.uuidString) // "\(primaryKey)"
        
        do {
            let test = try managedContext.fetch(fetchRequest)
            let objectToDelete = test[0] as! NSManagedObject
            managedContext.delete(objectToDelete)
            do {
                try managedContext.save()
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }
}
