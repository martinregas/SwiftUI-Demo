//
//  CharQuote.swift
//  Swift-UI-App
//
//  Created by Martin Regas on 14/08/2022.
//

import Foundation

struct CharQuote: Codable, Identifiable {
    var id = UUID()
    var quote: String
    var character: String
    var image: String
    var characterDirection: String
    
    private enum CodingKeys: String, CodingKey { case quote, image, character, characterDirection }
}

extension CharQuote: Equatable {
    static func ==(lhs: CharQuote, rhs: CharQuote) -> Bool {
        return lhs.character == rhs.character && lhs.quote == rhs.quote
    }
}
