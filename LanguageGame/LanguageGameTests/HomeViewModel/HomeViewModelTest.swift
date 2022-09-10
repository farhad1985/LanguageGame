//
//  HomeViewModelTest.swift
//  LanguageGameTests
//
//  Created by Farhad on 9/10/22.
//

import XCTest
import Combine
@testable import LanguageGame

class HomeViewModelTest: XCTestCase {

    private var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        try super.setUpWithError()
        cancellables = []
    }

    override func tearDownWithError() throws {
    }

    func testResetGame() throws {
        let repo = MockWordReposiory()
        let usecase = try DefaultRandomWordLogic(repo: repo)
        let sut = HomeViewModel(randomWordGameLogic: usecase)
        
        let expectation = self.expectation(description: "testStartGame")

        sut.$currentWord.sink(receiveValue: { value in
            if value != nil {
                expectation.fulfill()
            }
        }).store(in: &cancellables)

        sut.resetGame()
        
        waitForExpectations(timeout: 2)

        XCTAssertNotNil(sut.currentWord, "current word is nil")
        XCTAssertNotNil(sut.currentWord?.english, "english phrase of current word is nil")
        XCTAssertNotNil(sut.currentWord?.spanish, "spanish phrase of current word is nil")
        XCTAssertNotNil(sut.currentWord?.isCorrect, "isCorrect flag of current word is nil")
    }

    func testWrongAttemptsCounter() throws {
        let repo = MockWordReposiory()
        let usecase = try DefaultRandomWordLogic(repo: repo)
        let sut = HomeViewModel(randomWordGameLogic: usecase)

        sut.resetGame()

        var word: RandomWord?
        
        let expectation = self.expectation(description: "testWrongAttemptsCounter")

        sut.$wrongAttempts.sink(receiveValue: { value in
            if value > 0 {
                expectation.fulfill()
            }
        }).store(in: &cancellables)

        sut.$currentWord.sink(receiveValue: { value in
            if word == nil {
                word = value
                DispatchQueue.main.async {
                    sut.answer(isCorrect: !(word?.isCorrect ?? false))
                }
            }
        }).store(in: &cancellables)

        waitForExpectations(timeout: 2)

        XCTAssertTrue(sut.wrongAttempts == 1)
    }

    
    func testCorrectAttemptsCounter() throws {
        let repo = MockWordReposiory()
        let usecase = try DefaultRandomWordLogic(repo: repo)
        let sut = HomeViewModel(randomWordGameLogic: usecase)

        sut.resetGame()

        var word: RandomWord?
        
        let expectation = self.expectation(description: "testCorrectAttemptsCounter")

        sut.$correctAttempts.sink(receiveValue: { value in
            if value > 0 {
                expectation.fulfill()
            }
        }).store(in: &cancellables)

        sut.$currentWord.sink(receiveValue: { value in
            if word == nil {
                word = value
                DispatchQueue.main.async {
                    sut.answer(isCorrect: word?.isCorrect ?? false)
                }
            }
        }).store(in: &cancellables)

        waitForExpectations(timeout: 2)

        XCTAssertTrue(sut.correctAttempts == 1)
    }

    func testGameFinishedWithWrongTry() throws {
        let repo = MockWordReposiory()
        let usecase = try DefaultRandomWordLogic(repo: repo)
        let sut = HomeViewModel(randomWordGameLogic: usecase)

        let expectation = self.expectation(description: "testGameFinishedWithWrongTry")

        sut.$isFinished.sink(receiveValue: { value in
            if value == true {
                expectation.fulfill()
            }
        }).store(in: &cancellables)

        sut.$currentWord.sink(receiveValue: { value in
            if value != nil {
                DispatchQueue.main.async {
                    sut.answer(isCorrect: !(value?.isCorrect ?? false))
                }
            }
        })
        .store(in: &cancellables)

        sut.resetGame()

        waitForExpectations(timeout: 2)

        XCTAssertTrue(sut.wrongAttempts == 3)
    }

    func testGameFinishedWithCorrectTry() throws {
        let repo = MockWordReposiory()
        let usecase = try DefaultRandomWordLogic(repo: repo)
        let sut = HomeViewModel(randomWordGameLogic: usecase)

        let expectation = self.expectation(description: "testGameFinishedWithCorrectTry")

        sut.$isFinished.sink(receiveValue: { value in
            if value == true {
                expectation.fulfill()
            }
        }).store(in: &cancellables)

        sut.$currentWord.sink(receiveValue: { value in
            if value != nil {
                DispatchQueue.main.async {
                    sut.answer(isCorrect: sut.currentWord?.isCorrect ?? false)
                }
            }
        }).store(in: &cancellables)

        sut.resetGame()

        waitForExpectations(timeout: 5)

        XCTAssertTrue(sut.correctAttempts == 15, "\(sut.correctAttempts)")
    }

}
