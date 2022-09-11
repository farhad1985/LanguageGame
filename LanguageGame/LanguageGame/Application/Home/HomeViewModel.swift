//
//  HomeViewModel.swift
//  LanguageGame
//
//  Created by Farhad on 9/8/22.
//

import Foundation
import Combine

class HomeViewModel {
    
    @Published var currentWord: RandomWord?
    @Published var correctAttempts: Int = 0
    @Published var wrongAttempts: Int = 0
    @Published var isFinished: Bool = false
    @Published var secondsRemaining = 0


    let gameTime = 5
    
    var resultMatch: String {
        return "\(NSLocalizedString("yourScore", comment: "yourScore")): \(correctAttempts)"
    }
    
    private let randomWordGameLogic: RandomWordGameLogic
    private let totalQuestions = 15
    private let validWrongAttempts = 3
    
    private var timer: Timer?

    init(randomWordGameLogic: RandomWordGameLogic) {
        self.randomWordGameLogic = randomWordGameLogic
    }
    
    func answer(isCorrect: Bool, isTimeOut: Bool = false) {
        
        if isTimeOut {
            wrongAttempts += 1
            
        } else if (currentWord?.isCorrect ?? false) == isCorrect {
            correctAttempts += 1
            
        } else {
            wrongAttempts += 1
            
        }
        
        if wrongAttempts + correctAttempts == totalQuestions ||
            wrongAttempts == validWrongAttempts {
            
            isFinished = true
            
        } else {
            currentWord = randomWordGameLogic.fetchNewWord()
        }
    }

    func resetGame() {
        isFinished = false
        correctAttempts = 0
        wrongAttempts = 0
        randomWordGameLogic.resetWords()
        currentWord = randomWordGameLogic.fetchNewWord()
        startTimer()
    }
    
    func restTimer() {
        secondsRemaining = gameTime
    }
    
    func stopGame() {
        timer?.invalidate()
    }
    
    private func startTimer() {
        secondsRemaining = gameTime
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(updateTimer),
            userInfo: nil,
            repeats: true)
    }
    
    @objc func updateTimer() {
        if secondsRemaining > 0 {
            secondsRemaining -= 1
            
        } else {
            secondsRemaining = gameTime
            answer(isCorrect: false, isTimeOut: true)
        }
    }
}
