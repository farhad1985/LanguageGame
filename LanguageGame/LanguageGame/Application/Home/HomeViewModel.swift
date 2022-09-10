//
//  HomeViewModel.swift
//  LanguageGame
//
//  Created by Farhad on 9/8/22.
//

import Foundation
import Combine

class HomeViewModel {
    private var randomWordGameLogic: RandomWordGameLogic
    
    @Published var currentWord: RandomWord?
    @Published var correctAttempts: Int = 0
    @Published var wrongAttempts: Int = 0
    
    private let totalQuestions = 15
    private let validWrongAttempts = 3
    

    init(randomWordGameLogic: RandomWordGameLogic) {
        self.randomWordGameLogic = randomWordGameLogic
    }
    
    func answer(isCorrect: Bool) {
        if (currentWord?.isCorrect ?? false) == isCorrect {
            correctAttempts += 1
        } else {
            wrongAttempts += 1
        }
        
        currentWord = randomWordGameLogic.fetchNewWord()
    }

    func resetGame() {
        correctAttempts = 0
        wrongAttempts = 0
        randomWordGameLogic.resetWords()
        currentWord = randomWordGameLogic.fetchNewWord()
    }
}
