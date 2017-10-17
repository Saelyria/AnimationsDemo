
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.lightGray
        let rootNavController = UINavigationController(rootViewController: MainViewController())
        self.window?.rootViewController = rootNavController
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

