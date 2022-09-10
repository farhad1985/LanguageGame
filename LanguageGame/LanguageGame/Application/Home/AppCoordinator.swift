//
//  AppCoordinator.swift
//  LanguageGame
//
//  Created by Farhad on 9/9/22.
//

import UIKit

class AppCoordinator {
    
    let navigation: UINavigationController
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
        navigation.view.backgroundColor = .white
    }
    
    func start() {
        let repo = WordListRepository()
        
        do {
            let randomWordGameLogic = try DefaultRandomWordLogic(repo: repo)
            let viewModel = HomeViewModel(randomWordGameLogic: randomWordGameLogic)
            let vc = HomeVC(viewModel: viewModel)
            
            navigation.pushViewController(vc, animated: false)
            
        } catch let error as GameError {
            showError(message: error.desc)
            
        } catch {
            showError(message: error.localizedDescription)
        }
    }
    
    func showError(message: String) {
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
