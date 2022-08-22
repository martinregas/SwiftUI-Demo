//
//  CharQuoteView.swift
//  Swift-UI-App
//
//  Created by Martin Regas on 14/08/2022.
//

import SwiftUI
import CachedAsyncImage

struct CharQuoteView: View {
    @EnvironmentObject var favoriteQuotesManager: FavoriteQuotesManager
    @Binding var charQuote: CharQuote
    
    var body: some View {
        VStack {
            HStack() {
                Spacer()
                CachedAsyncImage(
                    url: URL(string: charQuote.image),
                    content: { image in
                        image.resizable(resizingMode: .stretch)
                            .aspectRatio(contentMode: .fit)
                            .padding(10)
                    },
                    placeholder: {
                        ProgressView()
                    }
                )
                Spacer()
            }
            
            Spacer()
            
            Text(charQuote.character)
                .font(Font.custom("Simpsonfont", size: 30))
                .foregroundColor(Colors.primary)
                .shadow(color: Colors.secondary, radius: 1, x: -1, y: 0)
                .glowBorder(color: Colors.secondary, lineWidth: 1)
                .padding([.trailing, .leading], 20)
                .padding([.top, .bottom], 10)
                .minimumScaleFactor(0.2)
                .lineLimit(2)
                .multilineTextAlignment(.center)
            
            Text(charQuote.quote)
                .font(.body)
                .padding([.trailing, .leading], 15)
                .padding(.bottom, 20)
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
            
        }
        .overlay(
            HStack() {
                Spacer()
                VStack() {
                    Image(systemName: favoriteQuotesManager.checkIsFavorite(charQuote: charQuote) ? "star.fill" : "star")
                        .font(.system(size: 25))
                        .padding(10)
                        .foregroundColor(Colors.primary)
                        .onTapGesture {
                            favoriteQuotesManager.changeFavoriteStatus(charQuote: charQuote)
                        }
                    Spacer()
                }}
        )
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .init(red: 0, green: 0, blue: 0, opacity: 0.1), radius: 4, x: 0, y: 0)
        .padding([.leading, .trailing], 50)
        .padding([.bottom, .top], 20)
    }
}


struct CharQuoteView_Previews: PreviewProvider {
    @State static var charQuote = CharQuote(quote: "When I look at people I don't see colors; I just see crackpot religions.", character: "Chief Wiggum", image: "https://cdn.glitch.com/3c3ffadc-3406-4440-bb95-d40ec8fcde72%2FChiefWiggum.png?1497567511716", characterDirection: "Left")
    
    static var previews: some View {
        CharQuoteView(charQuote: $charQuote)
    }
}
