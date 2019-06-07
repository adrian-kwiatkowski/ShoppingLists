import UIKit
import CoreData

struct DataManager {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func fetchCurrentLists() -> [List]? {
        var resultsArray = [List]()
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Lists")
        request.predicate = NSPredicate(format: "archived == false")
        do {
            
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let fetchedListName = data.value(forKey: "name") as! String
                let fetchedListCreatedDate = data.value(forKey: "createdAt") as! Date
                let fetchedListArchived = data.value(forKey: "archived") as! Bool
                
                let fetchedList = List(name: fetchedListName, createdAt: fetchedListCreatedDate, archived: fetchedListArchived)
                resultsArray.append(fetchedList)
            }
            return resultsArray
            
        } catch {
            print("Failed")
            return nil
        }
    }
    
    func fetchArchivedLists() -> [List]? {
        var resultsArray = [List]()
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Lists")
        request.predicate = NSPredicate(format: "archived == true")
        do {
            
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let fetchedListName = data.value(forKey: "name") as! String
                let fetchedListCreatedDate = data.value(forKey: "createdAt") as! Date
                let fetchedListArchived = data.value(forKey: "archived") as! Bool
                
                let fetchedList = List(name: fetchedListName, createdAt: fetchedListCreatedDate, archived: fetchedListArchived)
                resultsArray.append(fetchedList)
            }
            return resultsArray
            
        } catch {
            print("Failed")
            return nil
        }
    }
    
    func createNewList(with name: String) {
        let newList = List(name: name)
        
        let entity = NSEntityDescription.entity(forEntityName: "Lists", in: context)
        let newListManagedObject = NSManagedObject(entity: entity!, insertInto: context)
        
        newListManagedObject.setValue(newList.name, forKey: "name")
        newListManagedObject.setValue(newList.createdAt, forKey: "createdAt")
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
        request.predicate = NSPredicate(format: "name == %@ AND createdAt == %@ AND archived == false", argumentArray: [list.name, list.createdAt])
        if let result = try? context.fetch(request) {
            for object in result as! [NSManagedObject] {
                object.setValue(true, forKey: "archived")
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
        request.predicate = NSPredicate(format: "name == %@ AND createdAt == %@ AND archived == true", argumentArray: [list.name, list.createdAt])
        if let result = try? context.fetch(request) {
            for object in result as! [NSManagedObject] {
                context.delete(object)
                print("successfully deleted: \(list)")
            }
        }
    }
}
