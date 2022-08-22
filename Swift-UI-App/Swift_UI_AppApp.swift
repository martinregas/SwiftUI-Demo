//
//  Swift_UI_AppApp.swift
//  Swift-UI-App
//
//  Created by Martin Regas on 14/08/2022.
//

import SwiftUI

@main
struct Swift_UI_AppApp: App {
    @StateObject var favoriteQuotesManager = FavoriteQuotesManager()

    var body: some Scene {
        WindowGroup {
            MainView().environmentObject(favoriteQuotesManager)
        }
    }
}
