//
//  ContentView.swift
//  SwiftUI - Flight Ticket Purchase
//
//  Created by Hamed Majdi on 3/9/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader{ /// what does GeometryReader do? It allows you to read the size of the screen
            let size = $0.size /// what does $0.size do? It gets the size of the screen
            let safeArea = $0.safeAreaInsets /// what does $0.safeAreaInsets do? It gets the safe area of the screen
            Home(size: size, safeArea: safeArea)
                .ignoresSafeArea(.container, edges: .vertical) 
        }
    }
}


#Preview {
    ContentView()
}
