//
//  ContentView.swift
//  Swift-UI-App
//
//  Created by Martin Regas on 14/08/2022.
//

import SwiftUI

struct RandomQuotesView: View {
    @EnvironmentObject private var favoriteQuotesManager: FavoriteQuotesManager
    
    @StateObject private var observed = Observed()
    
    var body: some View {
        VStack {
            SearchBar(textToSearch: $observed.textToSearch, delayToSearch: 1, search: {
                observed.getQuotes(reset: true)
            })
            
            Spacer()
            
            if !observed.quotesNotFound  {
                ZStack {
                    ForEach($observed.charQuotes, id: \.id) { charQuote in
                        if charQuote.id == observed.charQuotes.last?.id {
                            
                            CharQuoteView(charQuote: charQuote)
                                .offset(x: observed.skippingQuote ? -UIScreen.main.bounds.height : 0)
                                .rotationEffect( observed.skippingQuote ? .degrees(Double(-50)) : .degrees(0))
                            
                                .scaleEffect(observed.addingToFavorites ? 0.1 : 1)
                                .offset(x: observed.addingToFavorites ? UIScreen.main.bounds.width/3-35 : 0, y:  observed.addingToFavorites ? UIScreen.main.bounds.height/2: 0)
                                .opacity(observed.addingToFavorites ? 0.7 : 1)
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
            else if !observed.isLoading {
                ErrorInformationView(type: .noChars)
                    .padding([.leading, .trailing], 10)
                    .onTapGesture {
                        observed.textToSearch.removeAll()
                    }
            }
        
            if observed.isLoading && observed.charQuotes.isEmpty {
                Spinner(style: .large)
                    .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            HStack {
                Button("SKIP", action: {
                    if observed.skippingQuote {
                        return
                    }
                    
                    withAnimation(.easeOut(duration: 1), {
                        observed.skippingQuote.toggle()
                    })
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        observed.next()
                        observed.skippingQuote.toggle()
                    }
                })
                .buttonStyle(RoundedButton())
                
                Button(observed.currentQuoteIsFavorite ? "DISLIKE" : "LIKE",action: {
                    if observed.addingToFavorites {
                        return
                    }
                    
                    if observed.currentQuoteIsFavorite {
                        observed.showAlert = true
                        return
                    }
                    
                    withAnimation(.easeOut(duration: 0.5), {
                        observed.addingToFavorites.toggle()
                    })
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        guard let quote = observed.charQuotes.last else { return }
                        favoriteQuotesManager.addQuote(charQuote: quote)
                        observed.next()
                        observed.addingToFavorites.toggle()
                    }
                })
                .buttonStyle(RoundedButton(backgroundColor: observed.currentQuoteIsFavorite ? .red : .white))
            }
            .disabled(observed.charQuotes.isEmpty)
            .padding(50)
        }
        .onChange(of: favoriteQuotesManager.quotes) { _ in
            checkIfCurrentQuoteIsFavorite()
        }
        .background(Colors.primary)
        .alert("Are you sure you want to remove this quote from your favorites list?", isPresented: $observed.showAlert) {
            Button("YES!, REMOVE IT.") {
                guard let quote = observed.charQuotes.last else { return }
                favoriteQuotesManager.removeQuote(charQuote: quote)
            }
            Button("NO, I CHANGED MY MIND.", role: .cancel) { }
        }
        .ignoresSafeArea(.keyboard)
    }

    func checkIfCurrentQuoteIsFavorite() {
        guard let currentCharQuote = observed.charQuotes.last else { return }
        observed.currentQuoteIsFavorite = favoriteQuotesManager.checkIsFavorite(charQuote: currentCharQuote)
    }
}

struct RandomQuotesView_Previews: PreviewProvider {
    static var previews: some View {
        RandomQuotesView()
    }
}
