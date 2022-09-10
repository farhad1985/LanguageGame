//
//  RandomWord.swift
//  LanguageGame
//
//  Created by Farhad on 9/8/22.
//

struct RandomWord {
    var english: String
    var spanish: String
    var isCorrect: Bool
    
    init(word: Word, isCorrect: Bool) {
        self.english = word.english
        self.spanish = word.spanish
        self.isCorrect = isCorrect
    }
}
