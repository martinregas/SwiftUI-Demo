//
//  MainView.swift
//  Swift-UI-App
//
//  Created by Martin Regas on 15/08/2022.
//

import SwiftUI

struct MainView: View {
    
    var body: some View {
        TabView {
            RandomQuotesView()
                .tabItem {
                    Label("Random", systemImage: "house")
                        .foregroundColor(.white)
                }
                .environmentObject(CharQuotesManager())

            FavoriteQuotesListView()
                .tabItem {
                    Label("Favorites", systemImage: "star")
                        .foregroundColor(.white)
                }
        }
        .accentColor(.white) 
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
