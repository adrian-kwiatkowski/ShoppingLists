import UIKit
import CoreData

protocol DataManager {
    
}

extension DataManager {
    
    func save(_ context: NSManagedObjectContext) {
        do {
            try context.save()
            print("successully saved context")
        } catch {
            print("Failed saving context")
        }
    }
}
