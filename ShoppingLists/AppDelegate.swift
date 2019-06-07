import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let homeViewController = UITabBarController()
        window!.rootViewController = homeViewController
        
        
        let firstVC = UINavigationController(rootViewController: CurrentListsViewController())
        firstVC.tabBarItem = UITabBarItem(title: "Current", image: #imageLiteral(resourceName: "iconCurrent"), tag: 0)
        
        let secondVC = UINavigationController(rootViewController: ArchivedListsViewController())
        secondVC.tabBarItem = UITabBarItem(title: "Archived", image: #imageLiteral(resourceName: "iconArchived"), tag: 1)
        
        homeViewController.viewControllers = [firstVC, secondVC]
        
        window!.makeKeyAndVisible()
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "ShoppingLists")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

