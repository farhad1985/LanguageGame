//
//  MockWordReposiory.swift
//  LanguageGameTests
//
//  Created by Farhad on 9/10/22.
//

import Foundation
@testable import LanguageGame

struct MockWordReposiory: WordRepository {
    
    func loadWords() throws -> [Word] {
        let word1 = Word(english: "Hello", spanish: "Hola")
        let word2 = Word(english: "goodbye", spanish: "adiós")
        let word3 = Word(english: "what's up", spanish: "Qué pasa")
        let word4 = Word(english: "Thanks", spanish: "Gracias")
        let word5 = Word(english: "always", spanish: "siempre")
        
        return [word1, word2, word3, word4, word5]
    }
}
