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
        
        let nav = UINavigationController()
        window = UIWindow(windowScene: windowScene)
        
        
        nav.view.backgroundColor = .white
        window?.overrideUserInterfaceStyle = .light
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        do {
            let wordRepository = WordListRepository()
            let logicWordGame = try DefaultRandomWordLogic(repo: wordRepository)
            
            let coordinator = AppCoordinator(navigation: nav,
                                             logicWordGame: logicWordGame)
            
            
            coordinator.start()
            
        } catch {
            showError(navigation: nav, message: error.localizedDescription)
        }
    }
    
    private func showError(navigation: UINavigationController,
                           message: String) {
        
        let alertVC = UIAlertController(title: "",
                                        message: message,
                                        preferredStyle: .alert)
        
        let okTitle = NSLocalizedString("ok", comment: "ok")
        let actionOK = UIAlertAction(title: okTitle,
                                     style: .cancel)
        
        alertVC.addAction(actionOK)
        
        navigation.present(alertVC, animated: true)
    }
}
