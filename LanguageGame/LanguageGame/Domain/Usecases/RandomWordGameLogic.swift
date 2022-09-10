//
//  RandomWordGame.swift
//  LanguageGame
//
//  Created by Farhad on 9/8/22.
//

protocol RandomWordGameLogic {
    func fetchNewWord() -> RandomWord?
    func resetWords()
}
