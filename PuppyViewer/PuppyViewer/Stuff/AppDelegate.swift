
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.lightGray
        
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [ NSAttributedStringKey.foregroundColor: UIColor.white ]
        
        let rootNavController = UINavigationController(rootViewController: CollectionViewController())
        rootNavController.navigationBar.barStyle = .blackOpaque
        self.window?.rootViewController = rootNavController
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

