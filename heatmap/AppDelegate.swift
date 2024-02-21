//
//  AppDelegate.swift
//  heatmap
//
//  Created by srivatsa davuluri on 21/02/24.
//

import UIKit
import GoogleMaps
import GooglePlaces



@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    let mapsAPIKey = "AIzaSyCYEdgNypvnHFsW1SuuEgYCqz5t7H_L534"
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey(mapsAPIKey)
        GMSPlacesClient.provideAPIKey(mapsAPIKey)
        return true
    }
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
}

