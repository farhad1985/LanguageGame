//
//  DefaultRandomWordLogicTest.swift
//  LanguageGameTests
//
//  Created by Farhad on 9/10/22.
//

import XCTest
@testable import LanguageGame

class DefaultRandomWordLogicTest: XCTestCase {
    
    func testIntializeLogic() throws {
        // arragment
        let repo = MockWordReposiory()
        let _ = try DefaultRandomWordLogic(repo: repo)
    }
    
    func testResetRemainingIndexes() {
        do {
            // arragment
            let repo = MockWordReposiory()
            let sut = try DefaultRandomWordLogic(repo: repo)
            
            // action
            let allwords = try repo.loadWords()
            let _ = sut.fetchNewWord()
            sut.resetWords()
            
            // assert
            XCTAssertEqual(sut.remainingIndexes.count, allwords.count)
        } catch {
            // assert
            XCTFail(error.localizedDescription)
        }
    }
    
    func testPickCorrentWordPair() {
        do {
            // arragment
            let repo = MockWordReposiory()
            let sut = try DefaultRandomWordLogic(repo: repo)
            
            // action
            let correctWord = sut.pickCorrentWordPair()
            
            // assert
            XCTAssertNotNil(correctWord)
        } catch {
            // assert
            XCTFail(error.localizedDescription)
        }
    }
    
    func testPickIncorrentWordPair() {
        do {
            // arragment
            let repo = MockWordReposiory()
            let sut = try DefaultRandomWordLogic(repo: repo)
            
            // action
            let incorrectWord = sut.pickIncorrentWordPair()
            
            // assert
            XCTAssertNotNil(incorrectWord)
        } catch {
            // assert
            XCTFail(error.localizedDescription)
        }
    }
    
    
    func testfetchNewWord() {
        
        do {
            // arrangment
            let repo = MockWordReposiory()
            let sut = try DefaultRandomWordLogic(repo: repo)
            let allwords = try repo.loadWords()
            
            // action
            
            guard
                let randomWord = sut.fetchNewWord()
            else {
                
                // assert
                XCTFail("I couldn't load any words")
                return
            }
            
            let findWord = allwords
                .filter { $0.english == randomWord.english }
                .first
            
            if randomWord.isCorrect {
                XCTAssertEqual(findWord!.spanish, randomWord.spanish)
            } else {
                XCTAssertNotEqual(findWord!.spanish, randomWord.spanish)
            }
            
        } catch {
            // assert
            XCTFail(error.localizedDescription)
        }
    }
}
