import UIKit
import CoreData

struct DataManager {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func fetchProducts(for parentList: List) -> [Product] {
        
        var resultsArray = [Product]()
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Products")
        request.predicate = NSPredicate(format: "parentListName == %@ AND parentListLastModificationDate == %@", argumentArray: [parentList.name, parentList.lastModificationDate])
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let fetchedProductName = data.value(forKey: "name") as! String
                let fetchedProductLastModificationDate = data.value(forKey: "lastModificationDate") as! Date
                
                let fetchedProduct = Product(name: fetchedProductName, lastModificationDate: fetchedProductLastModificationDate, parentList: (parentList.name, parentList.lastModificationDate))
                resultsArray.append(fetchedProduct)
            }
            return resultsArray
        } catch {
            print("Failed to load products for list \(parentList)")
            return []
        }
    }
    
    func fetchCurrentLists() -> [List] {
        var resultsArray = [List]()
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Lists")
        request.predicate = NSPredicate(format: "archived == false")
        request.sortDescriptors = [NSSortDescriptor(key: "lastModificationDate", ascending: true)]
        do {
            
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let fetchedListName = data.value(forKey: "name") as! String
                let fetchedListLastModificationDate = data.value(forKey: "lastModificationDate") as! Date
                let fetchedListArchived = data.value(forKey: "archived") as! Bool
                
                let fetchedList = List(name: fetchedListName, lastModificationDate: fetchedListLastModificationDate, archived: fetchedListArchived)
                resultsArray.append(fetchedList)
            }
            return resultsArray
            
        } catch {
            print("Failed to load current lists")
            return []
        }
    }
    
    func fetchArchivedLists() -> [List] {
        var resultsArray = [List]()
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Lists")
        request.predicate = NSPredicate(format: "archived == true")
        request.sortDescriptors = [NSSortDescriptor(key: "lastModificationDate", ascending: true)]
        do {
            
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let fetchedListName = data.value(forKey: "name") as! String
                let fetchedListLastModificationDate = data.value(forKey: "lastModificationDate") as! Date
                let fetchedListArchived = data.value(forKey: "archived") as! Bool
                
                let fetchedList = List(name: fetchedListName, lastModificationDate: fetchedListLastModificationDate, archived: fetchedListArchived)
                resultsArray.append(fetchedList)
            }
            return resultsArray
            
        } catch {
            print("Failed to load archived lists")
            return []
        }
    }
    
    func createNewProduct(with name: String, parentList: List) {
        let newProduct = Product(name: name, parentList: (parentList.name, parentList.lastModificationDate))
        
        let entity = NSEntityDescription.entity(forEntityName: "Products", in: context)
        let newListManagedObject = NSManagedObject(entity: entity!, insertInto: context)
        
        newListManagedObject.setValue(newProduct.name, forKey: "name")
        newListManagedObject.setValue(newProduct.lastModificationDate, forKey: "lastModificationDate")
        newListManagedObject.setValue(newProduct.parentList.name, forKey: "parentListName")
        newListManagedObject.setValue(newProduct.parentList.lastModificationDate, forKey: "parentListLastModificationDate")
        
        do {
            try context.save()
            print("successully saved product: \(newProduct)")
        } catch {
            print("Failed saving")
        }
    }
    
    func createNewList(with name: String) {
        let newList = List(name: name)        
        
        let entity = NSEntityDescription.entity(forEntityName: "Lists", in: context)
        let newListManagedObject = NSManagedObject(entity: entity!, insertInto: context)
        
        newListManagedObject.setValue(newList.name, forKey: "name")
        newListManagedObject.setValue(newList.lastModificationDate, forKey: "lastModificationDate")
        newListManagedObject.setValue(newList.archived, forKey: "archived")
        
        do {
            try context.save()
            print("successully saved list: \(newList)")
        } catch {
            print("Failed saving")
        }
    }
    
    func archive(_ list: List) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Lists")
        request.predicate = NSPredicate(format: "name == %@ AND lastModificationDate == %@ AND archived == false", argumentArray: [list.name, list.lastModificationDate])
        if let result = try? context.fetch(request) {
            for object in result as! [NSManagedObject] {
                object.setValue(true, forKey: "archived")
                object.setValue(Date(), forKey: "lastModificationDate")
                do {
                    try context.save()
                    print("successully updated list: \(list)")
                } catch {
                    print("Failed updating")
                }
            }
        }
    }
    
    func delete(_ list: List) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Lists")
        request.predicate = NSPredicate(format: "name == %@ AND lastModificationDate == %@ AND archived == true", argumentArray: [list.name, list.lastModificationDate])
        if let result = try? context.fetch(request) {
            for object in result as! [NSManagedObject] {
                context.delete(object)
                print("successfully deleted: \(list)")
            }
        }
    }
    
    func delete(_ product: Product) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Products")
        request.predicate = NSPredicate(format: "name == %@ AND lastModificationDate == %@ AND parentListName == %@ AND parentListLastModificationDate == %@", argumentArray: [product.name, product.lastModificationDate, product.parentList.name, product.parentList.lastModificationDate])
        if let result = try? context.fetch(request) {
            for object in result as! [NSManagedObject] {
                context.delete(object)
                print("successfully deleted: \(product)")
            }
        }
    }
}
