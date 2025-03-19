import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Jail Broken code
        if let jailbreakError = UIDevice.current.isJailBroken {
            debugPrint("Exit the application because it is jailbroken or create a ViewController and show the message", jailbreakError)
        }
        return true
    }
}
