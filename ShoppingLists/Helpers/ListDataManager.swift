import UIKit
import CoreData

struct ListDataManager: DataManager {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func createNewList(with name: String) {
        let newList = List(name: name)
        
        let entity = NSEntityDescription.entity(forEntityName: "Lists", in: context)
        let newListManagedObject = NSManagedObject(entity: entity!, insertInto: context)
        
        newListManagedObject.setValue(newList.name, forKey: "name")
        newListManagedObject.setValue(newList.lastModificationDate, forKey: "lastModificationDate")
        newListManagedObject.setValue(newList.archived, forKey: "archived")
        
        save(context)
    }
    
    func fetchLists(archived: Bool = false) -> [List] {
        var resultsArray = [List]()
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Lists")
        request.predicate = NSPredicate(format: "archived == %@", argumentArray: [archived])
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
            print("Failed to load lists")
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
                save(context)
            }
        }
        
        ProductDataManager().updateChildren(of: (list.name, list.lastModificationDate), with: modificationDate)
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
        
        ProductDataManager().deleteChildren(of: (list.name, list.lastModificationDate))
    }
}

