//
//  RoundedButton.swift
//  Swift-UI-App
//
//  Created by Martin Regas on 22/08/2022.
//

import SwiftUI

struct RoundedButton: ButtonStyle {
    var backgroundColor: Color = .white
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .glowBorder(color: Colors.secondary, lineWidth: 1)
            .shadow(color: Colors.secondary, radius: 1, x: -1, y: 0)
            .frame(maxWidth:.infinity , maxHeight: 50)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .font(Font.custom("Simpsonfont", size: 20))
            .foregroundColor(Colors.primary)
            .shadow(color: .init(red: 0, green: 0, blue: 0, opacity: 0.5), radius: 4, x: 0, y: 0)
            .animation(.easeOut(duration: 0.5), value: backgroundColor)
    }
}
