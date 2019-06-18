import UIKit
import CoreData

struct ProductDataManager {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
