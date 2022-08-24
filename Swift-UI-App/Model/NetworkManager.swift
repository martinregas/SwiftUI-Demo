//
//  NetworkManager.swift
//  Swift-UI-App
//
//  Created by Martin Regas on 14/08/2022.
//

import Foundation

enum LoadingState {
    case idle
    case loading
    case notFound
}

class NetworkManager: ObservableObject {
    @Published var charQuotes: [CharQuote] = []
    @Published var state: LoadingState = .idle
    
    func request(character:String) async throws {
        if state == .loading {
            return
        }
        
        if charQuotes.isEmpty {
            state = .loading
        }
        
        var characterParam = ""
        
        if !character.isEmpty {
            characterParam = "&character=\(character)"
        }
        
        guard let url = URL(string: "https://thesimpsonsquoteapi.glitch.me/quotes?count=10\(characterParam)") else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            Task { @MainActor in
                charQuotes = try JSONDecoder().decode([CharQuote].self, from: data)
                state = charQuotes.isEmpty ? .notFound : .idle
            }
        } catch {
            state = .notFound
        }
    }
}
