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
    @EnvironmentObject var networkManager: NetworkManager
    
    var body: some View {
        VStack {
            SearchBar(textToSearch: $textToSearch, delayToSearch: 1, search: {
                getQuotes(reset: true)
            })
            
            Spacer()

            switch networkManager.state {
            case .idle: quotesListView
            case .loading: spinnerView
            case .notFound: errorInformationView
            }
            
            Spacer()
            
            HStack {
                Button("SKIP", action: {
                    if skippingQuote {
                        return
                    }
                    
                    AnimationHandler().animate(duration: 0.75) {
                        skippingQuote.toggle()
                    } completion: {
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
                    
                    AnimationHandler().animate(duration: 0.5) {
                        addingToFavorites.toggle()
                    } completion: {
                        guard let quote = networkManager.charQuotes.last else { return }
                        favoriteQuotesManager.addQuote(charQuote: quote)
                        next()
                        addingToFavorites.toggle()
                    }
                })
                .buttonStyle(RoundedButton(backgroundColor: currentQuoteIsFavorite ? .red : .white))
            }
            .disabled($networkManager.charQuotes.isEmpty)
            .padding(50)
        }
        .onChange(of: favoriteQuotesManager.quotes) { _ in
            checkIfCurrentQuoteIsFavorite()
        }
        .background(Colors.primary)
        .alert("Are you sure you want to remove this quote from your favorites list?", isPresented: $showAlert) {
            Button("YES!, REMOVE IT.") {
                guard let quote = networkManager.charQuotes.last else { return }
                favoriteQuotesManager.removeQuote(charQuote: quote)
            }
            Button("NO, I CHANGED MY MIND.", role: .cancel) { }
        }
        .ignoresSafeArea(.keyboard)
        .task {
            try? await networkManager.request(character: textToSearch)
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
            ForEach($networkManager.charQuotes, id: \.id) { charQuote in
                if charQuote.id == networkManager.charQuotes.last?.id {
                    
                    CharQuoteView(charQuote: charQuote)
                        .offset(x: skippingQuote ? -UIScreen.main.bounds.width*1.6 : 0)
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
        guard let currentCharQuote = networkManager.charQuotes.last else { return }
        currentQuoteIsFavorite = favoriteQuotesManager.checkIsFavorite(charQuote: currentCharQuote)
    }
    
    func getQuotes(reset:Bool = false) {
        if reset {
            networkManager.charQuotes.removeAll()
        }
        
        Task {
            try? await networkManager.request(character: textToSearch)
        }
    }
    
    func next() {
        if networkManager.charQuotes.count <= 5 {
            getQuotes()
        }
        
        if !networkManager.charQuotes.isEmpty {
            networkManager.charQuotes.removeLast()
        }
    }
}

struct RandomQuotesView_Previews: PreviewProvider {
    static var previews: some View {
        RandomQuotesView()
    }
}
