//
//  SceneDelegate.swift
//  MyWeather
//
//  Created by nidhi.lalani on 18/03/23.
//

import UIKit
import CoreLocation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }

        /// set root based on data, if we already city data then it will show home screen with city data
        /// Otherwise it will start from introduction screen

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let city = UserDefaults.standard.string(forKey: Constants.Keys.city) {
            if let vc = storyboard.instantiateViewController(identifier: "HomeViewController") as? HomeViewController {
                let rootNC = UINavigationController(rootViewController: vc)
                let webService = WebServiceReal(baseUrlString: Constants.baseUrl, appId: Constants.appId)
                let weatherService = WeatherServiceReal(webService: webService)
                let location = CLLocation(latitude: UserDefaults.standard.double(forKey: Constants.Keys.lat), longitude: UserDefaults.standard.double(forKey: Constants.Keys.long))
                let homeviewModel = HomeViewModel(service: weatherService, currentLocation: location)
                vc.homeViewModel = homeviewModel
                vc.homeViewModel?.locality = city
                window?.rootViewController = rootNC
            }
        } else {
            if let vc = storyboard.instantiateViewController(identifier: "IntroductionViewController") as? IntroductionViewController {
                let rootNC = UINavigationController(rootViewController: vc)
                window?.rootViewController = rootNC
            }
        }
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

