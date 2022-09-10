//
//  RepositoryTest.swift
//  LanguageGameTests
//
//  Created by Farhad on 9/8/22.
//

import XCTest
@testable import LanguageGame

class RepositoryTest: XCTestCase {

    func testLoadWordsWithCount297() throws {
        // arragement
        let sut = WordListRepository()
        
        do {
            // action
            let words = try sut.loadWords()
            
            // assert
            XCTAssert(words.count == 297)
            
        } catch {
            // assert
            XCTFail(error.localizedDescription)
        }
    }

    func testRandomWord() throws {
        // arragement
        let sut = WordListRepository()
        
        do {
            // action
            let words = try sut.loadWords()
            let randomWord = words.randomElement()

            // assert
            XCTAssertNotNil(randomWord?.spanish)
            XCTAssertNotNil(randomWord?.english)
            XCTAssertFalse(randomWord?.spanish.isEmpty ?? true)
            XCTAssertFalse(randomWord?.english.isEmpty ?? true)

        } catch {
            // assert
            XCTFail(error.localizedDescription)
        }
    }
}



