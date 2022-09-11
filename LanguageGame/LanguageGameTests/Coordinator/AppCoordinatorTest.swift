//
//  AppCoordinatorTest.swift
//  LanguageGameTests
//
//  Created by Farhad on 9/11/22.
//

import XCTest
@testable import LanguageGame

class AppCoordinatorTest: XCTestCase {

    func testStart() throws {
        // arragement
        let navigation = UINavigationController()
        let mockWordRepository = MockWordReposiory()
        let logicWordGame = try DefaultRandomWordLogic(repo: mockWordRepository)
        let appCoordinator = AppCoordinator(navigation: navigation,
                                            logicWordGame: logicWordGame)
        
        // action
        let vc = appCoordinator.start()
        
        // assert
        XCTAssertNotNil(vc)
        XCTAssertNotNil(vc as? HomeVC)
    }
}
