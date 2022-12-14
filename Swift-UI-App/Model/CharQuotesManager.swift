//
//  CharQuotesManager.swift
//  Swift-UI-App
//
//  Created by Martin Regas on 14/08/2022.
//

import Foundation

enum LoadingState {
    case idle
    case notFound
    case loading
    case empty
}

class CharQuotesManager: ObservableObject {
    @Published var charQuotes: [CharQuote] = []
    @Published var state: LoadingState = .idle

    func request(character:String) async throws {
        if state == .loading || state == .empty {
            if charQuotes.isEmpty { state = .empty }
            return
        }
 
        state = charQuotes.isEmpty ? .empty : .loading
        
        var characterParam = ""
        
        if !character.isEmpty {
            characterParam = "&character=\(character)"
        }
        
        guard let url = URL(string: "https://thesimpsonsquoteapi.glitch.me/quotes?count=10\(characterParam)") else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            Task { @MainActor in
                let charQuotes = try JSONDecoder().decode([CharQuote].self, from: data)
                for charQuote in charQuotes {
                    if !self.charQuotes.contains(charQuote) {
                        self.charQuotes.insert(charQuote, at: 0)
                    }
                }
                state = charQuotes.isEmpty ? .notFound : .idle
            }
        } catch {
            state = .notFound
        }
    }
}
