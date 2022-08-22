//
//  FavoriteQuotesHelper.swift
//  Swift-UI-App
//
//  Created by Martin Regas on 15/08/2022.
//

import Foundation
import SwiftUI

@MainActor class FavoriteQuotesManager: ObservableObject {
    @AppStorage("FavoriteQuotes")
    private var quotesData = Data()
    
    @Published var quotes = [CharQuote]()
    
    init() {
        guard let quotes = try? JSONDecoder().decode([CharQuote].self, from: quotesData) else { return }
        self.quotes = quotes
    }
    
    private func updateQuotesStorage() {
        guard let quotesData = try? JSONEncoder().encode(quotes) else { return }
        self.quotesData = quotesData
    }
    
    func checkIsFavorite(charQuote: CharQuote) -> Bool {
        return !quotes.filter{$0 == charQuote}.isEmpty
    }
    
    func changeFavoriteStatus(charQuote: CharQuote) {
        if let index = quotes.firstIndex(of: charQuote) {
            quotes.remove(at: index)
        }
        else {
            quotes.append(charQuote)
        }
        updateQuotesStorage()
    }
    
    func addQuote(charQuote: CharQuote) {
        quotes.append(charQuote)
        updateQuotesStorage()
    }
    
    func removeQuote(charQuote: CharQuote) {
        if let index = quotes.firstIndex(of: charQuote) {
            quotes.remove(at: index)
            updateQuotesStorage()
        }
    }
    
    func removeQuote(at index: IndexSet) {
        quotes.remove(atOffsets: index)
        updateQuotesStorage()
    }
    
    func moveQuote(fromIndex:IndexSet, toIndex:Int) {
        quotes.move(fromOffsets: fromIndex, toOffset: toIndex)
        updateQuotesStorage()
    }
    
    func quotesByCharacter(character: String) -> [CharQuote] {
        if character.isEmpty { return quotes }
        return quotes.filter{ $0.character.contains(character) }
    }
}
