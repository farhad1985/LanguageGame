//
//  DefaultRandomWordLogic.swift
//  LanguageGame
//
//  Created by Farhad on 9/8/22.
//

import Foundation

class DefaultRandomWordLogic: RandomWordGameLogic {
    private var allWords: [Word] = []
    private(set) var remainingIndexes: [Int] = []
    private var repo: WordRepository
    
    init(repo: WordRepository) throws {
        self.repo = repo
        
        do {
            allWords = try repo.loadWords()
        } catch {
            throw error
        }
        
        resetWords()
    }
    
    func fetchNewWord() -> RandomWord? {
        if shouldPickCorrentAnswer(), let word = pickCorrentWordPair() {
            return RandomWord(word: word, isCorrect: true)
        }
        
        if let word = pickIncorrentWordPair() {
            return RandomWord(word: word, isCorrect: false)
        }
        
        return nil
    }
    
    func resetWords()  {
        let lastIndex = max(self.allWords.count - 1, 0)
        self.remainingIndexes = Array(0...lastIndex)
    }
    
    func pickCorrentWordPair() -> Word? {
        if remainingIndexes.count == 0 {
            resetWords()
        }
        
        if let word = remainingIndexes.randomElement() {
            if let ind = remainingIndexes.firstIndex(of: word) {
                remainingIndexes.remove(at: ind)
            }
            
            return allWords[word]
        }
        
        return nil
    }
    
    func pickIncorrentWordPair() -> Word? {
        if let word1 = allWords.randomElement(), let word2 = allWords.randomElement() {
            if word1.english != word2.english {
                return Word(english: word1.english,
                            spanish: word2.spanish)
                
            } else {
                return pickIncorrentWordPair()
            }
        }
        
        return nil
    }
    
    private func shouldPickCorrentAnswer() -> Bool {
        return Int.random(in: 0..<4) == 0
    }
}
