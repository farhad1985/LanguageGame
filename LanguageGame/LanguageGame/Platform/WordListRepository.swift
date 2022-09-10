//
//  WordListRepository.swift
//  LanguageGame
//
//  Created by Farhad on 9/8/22.
//

import Foundation

struct WordListRepository: WordRepository {
    
    func loadWords() throws -> [Word] {
        guard
            let url = Bundle.main.url(forResource: "words", withExtension: "json")
        else {
            throw GameError.notResource
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let models = try decoder.decode([Word].self, from: data)
            return models
            
        } catch {
            throw GameError.parseWordlist
        }
    }
    
}
