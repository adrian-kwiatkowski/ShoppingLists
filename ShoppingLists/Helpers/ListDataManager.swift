import UIKit
import CoreData

struct ListDataManager {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
    
    func archive(_ list: List) {
        let modificationDate = Date()
        
        let listRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Lists")
        listRequest.predicate = NSPredicate(format: "name == %@ AND lastModificationDate == %@ AND archived == false", argumentArray: [list.name, list.lastModificationDate])
        if let result = try? context.fetch(listRequest) {
            for object in result as! [NSManagedObject] {
                object.setValue(true, forKey: "archived")
                object.setValue(modificationDate, forKey: "lastModificationDate")
                do {
                    try context.save()
                    print("successully updated list: \(list)")
                } catch {
                    print("Failed updating list")
                }
            }
        }
        
        let productRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Products")
        productRequest.predicate = NSPredicate(format: "parentListName == %@ AND parentListLastModificationDate == %@", argumentArray: [list.name, list.lastModificationDate])
        if let result = try? context.fetch(productRequest) {
            for object in result as! [NSManagedObject] {
                object.setValue(modificationDate, forKey: "parentListLastModificationDate")
                object.setValue(modificationDate, forKey: "lastModificationDate")
                do {
                    try context.save()
                    print("successully updated products in: \(list)")
                } catch {
                    print("Failed updating products")
                }
            }
        }
    }
    
    func delete(_ list: List) {
        let listRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Lists")
        listRequest.predicate = NSPredicate(format: "name == %@ AND lastModificationDate == %@ AND archived == true", argumentArray: [list.name, list.lastModificationDate])
        if let result = try? context.fetch(listRequest) {
            for object in result as! [NSManagedObject] {
                context.delete(object)
                print("successfully deleted: \(list)")
            }
        }
        
        let productRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Products")
        productRequest.predicate = NSPredicate(format: "parentListName == %@ AND parentListLastModificationDate == %@", argumentArray: [list.name, list.lastModificationDate])
        if let result = try? context.fetch(productRequest) {
            for object in result as! [NSManagedObject] {
                context.delete(object)
                print("successfully deleted products in: \(list)")
            }
        }
    }
}

