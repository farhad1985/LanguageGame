//
//  WordRepository.swift
//  LanguageGame
//
//  Created by Farhad on 9/8/22.
//

protocol WordRepository {
    func loadWords() throws -> [Word]
}
