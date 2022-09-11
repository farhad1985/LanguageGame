//
//  AppCoordinator.swift
//  LanguageGame
//
//  Created by Farhad on 9/9/22.
//

import UIKit

protocol AppCoordinatorDelegate: AnyObject {
    typealias RestartGame = (UIAlertAction) -> ()
    
    func gameFinished(message: String, completion: @escaping RestartGame)
}

class AppCoordinator: Coordinator {
    
    private let navigation: UINavigationController
    private var delegate: AppCoordinatorDelegate?
    
    required init(navigation: UINavigationController) {
        
        self.navigation = navigation
        navigation.view.backgroundColor = .white
    }
    
    func start() {
        let repo = WordListRepository()
        
        do {
            let randomWordGameLogic = try DefaultRandomWordLogic(repo: repo)
            let viewModel = HomeViewModel(randomWordGameLogic: randomWordGameLogic)
            let vc = HomeVC(viewModel: viewModel)
            
            vc.delegateAppCoordinator = self
            
            navigation.pushViewController(vc, animated: false)
            
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

extension AppCoordinator: AppCoordinatorDelegate {
    
    func gameFinished(message: String, completion: @escaping RestartGame) {
        let endGameTitle = NSLocalizedString("endGame", comment: "end game")
        
        let alertVC = UIAlertController(title: endGameTitle,
                                        message: message,
                                        preferredStyle: .alert)
        
        let okTitle = NSLocalizedString("restart", comment: "restart")
        let actionRestart = UIAlertAction(title: okTitle,
                                          style: .default,
                                          handler: completion)
        
        let exitTitle = NSLocalizedString("exit", comment: "exit")
        let actionExit = UIAlertAction(title: exitTitle,
                                       style: .default) { _ in
            exit(0)
        }

        alertVC.addAction(actionExit)
        alertVC.addAction(actionRestart)

        navigation.present(alertVC, animated: true)
    }
    
}
