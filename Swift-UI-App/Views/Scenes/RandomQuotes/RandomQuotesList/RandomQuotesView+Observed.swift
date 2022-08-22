//
//  RandomQuotesView+Observed.swift
//  Swift-UI-App
//
//  Created by Martin Regas on 19/08/2022.
//

import SwiftUI

extension RandomQuotesView {
    class Observed: ObservableObject {
        @Published var charQuotes = [CharQuote]()
        @Published var quotesNotFound = false
        @Published var isLoading = false
        
        @Published var textToSearch: String = ""
        @Published var skippingQuote: Bool = false
        @Published var addingToFavorites: Bool = false
        @Published var favoriteButtonTitle: String = "LIKE"
        @Published var showAlert: Bool = false
        @Published var currentQuoteIsFavorite: Bool = false

        init() {
            getQuotes()
        }
        
        func getQuotes(reset:Bool = false) {
            if reset {
                charQuotes.removeAll()
            }
            
            isLoading = true
            
            NetworkManager().request(character: textToSearch) { charQuotes in
                self.quotesNotFound = charQuotes.isEmpty
                self.isLoading = false
                self.charQuotes.insert(contentsOf: charQuotes, at: 0)
            }
        }

        func next() {
            if charQuotes.count <= 5 && !isLoading {
                getQuotes()
            }
            
            if charQuotes.count > 0 {
                charQuotes.removeLast()
            }
        }
    }
}
