//
//  SearchBar.swift
//  Swift-UI-App
//
//  Created by Martin Regas on 19/08/2022.
//

import SwiftUI

struct SearchBar: View {
    @Binding var textToSearch: String
    
    var delayToSearch: TimeInterval = 0
    
    var rightBtnImage: Image?
    
    var search : (() -> Void)?
    var rightBtnTapped : (() -> Void)?
        
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Colors.primary)
               
                TextField("Search by character", text: $textToSearch)
                    .disableAutocorrection(true)
                    .keyboardType(.asciiCapable)
                    .onDebouncedChange (
                        of: $textToSearch,
                        debounceFor: delayToSearch
                    ) { _ in
                        search?()
                    }
                
                if let rightBtnImage = rightBtnImage {
                    rightBtnImage
                        .foregroundColor(Colors.primary)
                        .onTapGesture {
                            rightBtnTapped?()
                        }
                }
            }
            .foregroundColor(Colors.secondary)
            .padding([.leading, .trailing], 15)
        }
        .frame(height: 40)
        .cornerRadius(13)
        .padding()
    }
}
