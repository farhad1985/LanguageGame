//
//  Word.swift
//  LanguageGame
//
//  Created by Farhad on 9/8/22.
//

struct Word : Codable {
    var english: String
    var spanish: String
    
    enum CodingKeys : String, CodingKey {
        case english = "text_eng"
        case spanish = "text_spa"
    }
}
