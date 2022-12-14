//
//  ContentView.swift
//  Swift-UI-App
//
//  Created by Martin Regas on 14/08/2022.
//

import SwiftUI

struct RandomQuotesView: View {
    @State var textToSearch: String = ""
    @State var skippingQuote: Bool = false
    @State var addingToFavorites: Bool = false
    @State var showAlert: Bool = false
    @State var currentQuoteIsFavorite: Bool = false
    
    @EnvironmentObject private var favoriteQuotesManager: FavoriteQuotesManager
    @EnvironmentObject var charQuotesManager: CharQuotesManager
    
    var body: some View {
        VStack {
            SearchBar(textToSearch: $textToSearch, delayToSearch: 1, search: {
                getQuotes(reset: true)
            })
            
            Spacer()

            switch charQuotesManager.state {
            case .idle, .loading: quotesListView
            case .empty: spinnerView
            case .notFound: errorInformationView
            }
            
            Spacer()
            
            HStack {
                Button("SKIP", action: {
                    if skippingQuote {
                        return
                    }

                    withAnimation(.easeOut(duration: 1), {
                        skippingQuote.toggle()
                    })
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        next()
                        skippingQuote.toggle()
                    }
                })
                .buttonStyle(RoundedButton())
                
                Button(currentQuoteIsFavorite ? "DISLIKE" : "LIKE",action: {
                    if addingToFavorites {
                        return
                    }
                    
                    if currentQuoteIsFavorite {
                        showAlert = true
                        return
                    }
                    
                    withAnimation(.easeOut(duration: 0.5), {
                        addingToFavorites.toggle()
                    })
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        guard let quote = charQuotesManager.charQuotes.last else { return }
                        favoriteQuotesManager.addQuote(charQuote: quote)
                        next()
                        addingToFavorites.toggle()
                    }
                })
                .buttonStyle(RoundedButton(backgroundColor: currentQuoteIsFavorite ? .red : .white))
            }
            .disabled($charQuotesManager.charQuotes.isEmpty)
            .padding(50)
        }
        .onChange(of: favoriteQuotesManager.quotes) { _ in
            checkIfCurrentQuoteIsFavorite()
        }
        .background(Colors.primary)
        .alert("Are you sure you want to remove this quote from your favorites list?", isPresented: $showAlert) {
            Button("YES!, REMOVE IT.") {
                guard let quote = charQuotesManager.charQuotes.last else { return }
                favoriteQuotesManager.removeQuote(charQuote: quote)
            }
            Button("NO, I CHANGED MY MIND.", role: .cancel) { }
        }
        .ignoresSafeArea(.keyboard)
        .onAppear {
            getQuotes()
        }
    }
    
    var spinnerView: some View {
        Spinner(style: .large)
            .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
            .foregroundColor(.white)
    }
    
    var errorInformationView: some View {
        ErrorInformationView(type: .noChars)
            .padding([.leading, .trailing], 10)
            .onTapGesture {
                textToSearch.removeAll()
            }
            .onAppear() {
                currentQuoteIsFavorite = false
            }
    }
    
    var quotesListView: some View {
        ZStack {
            ForEach($charQuotesManager.charQuotes, id: \.id) { charQuote in
                if charQuote.id == charQuotesManager.charQuotes.last?.id {
                    
                    CharQuoteView(charQuote: charQuote)
                        .offset(x: skippingQuote ? -UIScreen.main.bounds.height : 0)
                        .rotationEffect( skippingQuote ? .degrees(Double(-50)) : .degrees(0))
                    
                        .scaleEffect(addingToFavorites ? 0.1 : 1)
                        .offset(x: addingToFavorites ? UIScreen.main.bounds.width/3-35 : 0, y:  addingToFavorites ? UIScreen.main.bounds.height/2: 0)
                        .opacity(addingToFavorites ? 0.7 : 1)
                        .onAppear(perform: {
                             checkIfCurrentQuoteIsFavorite()
                        })
                }
                else {
                    CharQuoteView(charQuote: charQuote)
                }
            }
        }
    }
    
    func checkIfCurrentQuoteIsFavorite() {
        guard let currentCharQuote = charQuotesManager.charQuotes.last else { return }
        currentQuoteIsFavorite = favoriteQuotesManager.checkIsFavorite(charQuote: currentCharQuote)
    }
    
    func next() {
        if !charQuotesManager.charQuotes.isEmpty {
            charQuotesManager.charQuotes.removeLast()
        }
                
        if charQuotesManager.charQuotes.count <= 5 {
            getQuotes()
        }
    }
    
    func getQuotes(reset:Bool = false) {
        if reset {
            charQuotesManager.charQuotes.removeAll()
        }
        
        Task {
            try? await charQuotesManager.request(character: textToSearch)
        }
    }
}

struct RandomQuotesView_Previews: PreviewProvider {
    static var previews: some View {
        RandomQuotesView()
    }
}
