//
//  GameErrorTest.swift
//  LanguageGameTests
//
//  Created by Farhad on 9/11/22.
//

import XCTest
@testable import LanguageGame

class GameErrorTest: XCTestCase {

    func testGameErrorNotFindResourceLocalizedDescription() {
        // arrangement
        let errorMessage = NSLocalizedString("notResourceError", comment: "")
        // action
        let error = GameError.notResource
        
        XCTAssertEqual(errorMessage, error.localizedDescription)
    }
    
    func testGameErrorNotParserLocalizedDescription() {
        // arrangement
        let errorMessage = NSLocalizedString("parseWordlist", comment: "")
        // action
        let error = GameError.parseWordlist
        
        XCTAssertEqual(errorMessage, error.localizedDescription)
    }
}
