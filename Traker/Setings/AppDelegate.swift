import UIKit
import CoreData
import YandexMobileMetrica

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: - Properties:
    let yandexMetrica = YandexMetrica.shared
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TrackerModels")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var window: UIWindow?
    
    // MARK: - Methods:
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        yandexMetrica.sendReport(about: Analytics.Events.close, and: nil, on: Analytics.Screens.appDelegate)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        yandexMetrica.sendReport(about: Analytics.Events.open, and: nil, on: Analytics.Screens.appDelegate)
    }
}


