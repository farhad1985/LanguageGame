//
//  SceneDelegate.swift
//  LanguageGame
//
//  Created by Farhad on 9/8/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        window?.overrideUserInterfaceStyle = .light
              
        let nav = UINavigationController()
        let coordinator = AppCoordinator(navigation: nav)

        window?.rootViewController = nav
        window?.makeKeyAndVisible()

        coordinator.start()
    }
}
