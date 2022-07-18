//
//  Copyright © 2020 Rosberry. All rights reserved.
//

import UIKit
import LedgerPayment

typealias LaunchOptions = [UIApplication.LaunchOptionsKey: Any]

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: LaunchOptions?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ExampleViewController()
        window?.makeKeyAndVisible()

        Ledger.start(sharedSecret: Constants.sharedSecret)
        Ledger.fetchProducts(withIdentifiers: [Constants.yearlySubscriptionIdentifier, Constants.monthlySubscriptionIdentifier])

        return true
    }
}
