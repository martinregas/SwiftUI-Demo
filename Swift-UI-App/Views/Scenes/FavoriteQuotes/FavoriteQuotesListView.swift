//
//  FavoriteQuotesView.swift
//  Swift-UI-App
//
//  Created by Martin Regas on 15/08/2022.
//

import SwiftUI

struct FavoriteQuotesListView: View {
    @EnvironmentObject var favoriteQuotesManager: FavoriteQuotesManager
    @Environment(\.editMode) private var editMode

    @State private var textToSearch: String = ""
    
    var body: some View {
        VStack{

            if !favoriteQuotesManager.quotes.isEmpty {
                SearchBar(textToSearch: $textToSearch, rightBtnImage: .init(systemName: "arrow.up.arrow.down"), rightBtnTapped: {
                    guard let editMode = editMode else { return }
                    withAnimation(.easeOut(duration: 0.2), {
                        editMode.wrappedValue = editMode.wrappedValue.isEditing ? .inactive : .active
                    })
                })
                                                                
                let filteredQuotes = favoriteQuotesManager.quotesByCharacter(character: textToSearch)
                
                if !filteredQuotes.isEmpty {
                    Spacer()
                    VStack {
                        List {
                            ForEach(filteredQuotes, id: \.id) { quote in
                                FavoriteQuoteView(quote: quote)
                            }
                            .onDelete { indexSet in
                                favoriteQuotesManager.removeQuote(at: indexSet)
                            }
                            .onMove { indexSet, index in
                                favoriteQuotesManager.moveQuote(fromIndex: indexSet, toIndex: index)
                            }
                        }
                        .listStyle(.plain)
                        .environment(\.editMode, editMode)

                    }
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding([.leading, .trailing, .bottom], 20)
                    Spacer()
                }
                else {
                    Spacer()
                    ErrorInformationView(type: .noChars)
                        .padding( 20)
                        .onTapGesture {
                            textToSearch.removeAll()
                        }
                    Spacer()
                }
            }
            else {
                Spacer()
                ErrorInformationView(type: .noFavorites)
                    .padding(20)
                Spacer()
            }
        }
        .frame(idealWidth: .infinity, maxWidth: .infinity)
        .background(Colors.primary)
        .ignoresSafeArea(.keyboard)
    }
}

struct FavoriteQuotesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteQuotesListView()
    }
}
