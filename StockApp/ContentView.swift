//
//  ContentView.swift
//  StockApp
//
//  Created by Alexandra Kravtsova on 18.10.23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            
            Color.theme.background.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 40) {
                Text("Accent Color")
                    .foregroundColor(.theme.tint)
                Text("Secondary Text Color")
                    .foregroundColor(.theme.secondaryText)
                Text("Green Color")
                    .foregroundColor(.theme.green)
                Text("Red Color")
                    .foregroundColor(.theme.red)
            }
            .font(.headline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
