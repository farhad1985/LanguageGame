//
//  GameError.swift
//  LanguageGame
//
//  Created by Farhad on 9/8/22.
//

import Foundation

enum GameError: LocalizedError {
    case notResource
    case parseWordlist
    
    var desc: String {
        switch self {
        case .notResource:
            return NSLocalizedString("notResourceError",
                                     comment: "I couldn't find word list")
            
        case .parseWordlist:
            return NSLocalizedString("parseWordlist",
                                     comment: "I couldn't parse word list")
        }
    }
}
