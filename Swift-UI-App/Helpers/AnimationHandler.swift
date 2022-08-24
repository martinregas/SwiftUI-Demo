//
//  AnimationHandler.swift
//  Swift-UI-App
//
//  Created by Martin Regas on 24/08/2022.
//

import SwiftUI

class AnimationHandler {
    func animate(duration:Double, starting: @escaping () -> Void, completion: @escaping () -> Void) {
        withAnimation(.easeOut(duration: duration), {
            starting()
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            completion()
        }
    }
}

