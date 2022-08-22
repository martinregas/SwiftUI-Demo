//
//  FavoriteQuoteView.swift
//  Swift-UI-App
//
//  Created by Martin Regas on 16/08/2022.
//

import SwiftUI
import CachedAsyncImage

struct FavoriteQuoteView: View {
    @EnvironmentObject var favoriteQuotesManager: FavoriteQuotesManager
    @State var quote: CharQuote
    
    var body: some View {
        HStack {
            CachedAsyncImage(
                url: URL(string: quote.image),
                content: { image in
                    image.resizable(resizingMode: .stretch)
                        .aspectRatio(contentMode: .fit)
                        .padding(10)
                },
                placeholder: {
                    ProgressView()
                }
            ).frame(width: 70, height: 70)
            
            VStack {
                Text(quote.character)
                    .font(Font.custom("Simpsonfont", size: 20))
                    .foregroundColor(Colors.primary)
                    .shadow(color: Colors.secondary, radius: 1, x: -1, y: 0)
                    .glowBorder(color: Colors.secondary, lineWidth: 1)
                    .padding([.trailing, .leading], 20)
                    .padding([.top, .bottom], 10)
                
                Text(quote.quote)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding([.trailing, .leading], 15)
                    .padding(.bottom, 10)
                    .font(.body)
                    .multilineTextAlignment(.center)
            }
        }
    }
}


struct FavoriteQuoteView_Previews: PreviewProvider {
    static var previews: some View {
        let charQuote = CharQuote(quote: "When I look at people I don't see colors; I just see crackpot religions.", character: "Chief Wiggum", image: "https://cdn.glitch.com/3c3ffadc-3406-4440-bb95-d40ec8fcde72%2FChiefWiggum.png?1497567511716", characterDirection: "Left")
        FavoriteQuoteView(quote: charQuote)
    }
}
