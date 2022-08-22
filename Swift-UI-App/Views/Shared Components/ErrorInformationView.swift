//
//  ErrorInformationView.swift
//  Swift-UI-App
//
//  Created by Martin Regas on 18/08/2022.
//

import SwiftUI

enum ErrorInfoType {
    case noChars
    case noFavorites
    
    var image: String {
        switch self {
        case .noChars: return "no-chars-image"
        case .noFavorites: return "no-favorites-image"
        }
    }
    
    var description: String {
        switch self {
        case .noChars: return "No phrase was found with that filter.\n\nTAP TO CLEAN FILTER"
        case .noFavorites: return "you don't have favorite quotes yet"
        }
    }
}

struct ErrorInformationView: View {
    var type: ErrorInfoType
    
    var body: some View {
        VStack {
            Text("TECHNICAL DIFFICULTIES")
                .font(.system(size: 30, weight: .bold))
                .padding([.top], 20)
                .padding([.leading, .trailing], 20)
                .multilineTextAlignment(.center)
            Image(type.image)
                .resizable(resizingMode: .stretch)
                .aspectRatio(contentMode: .fit)
                .padding(20)
            Text(type.description)
                .font(.system(size: 20, weight: .bold))
                .padding([.bottom], 20)
                .padding([.bottom, .top], 10)
                .padding([.leading, .trailing], 20)
                .multilineTextAlignment(.center)
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

struct ErrorInformationView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorInformationView(type: .noFavorites)
    }
}
