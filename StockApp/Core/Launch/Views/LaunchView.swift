//
//  LaunchView.swift
//  StockApp
//
//  Created by Alexandra Kravtsova on 23.11.23.
//

import SwiftUI

struct LaunchView: View {
    
    @Binding var showLaunchView: Bool
    
    @State private var loadingText: [String] = "Loading your portfolio...".map{ String($0) }
    @State private var showLoadingText: Bool = false
    
    @State private var counter: Int = 0
    @State private var loops: Int = 0
    
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        ZStack {
            Color.launch.background.ignoresSafeArea()
            
            Image("logo-transparent")
                .resizable()
                .frame(width: 100, height: 100)
            
            ZStack {
                if showLoadingText {
                    HStack(spacing: 0) {
                        ForEach(loadingText.indices, id: \.self) { index in
                            Text(loadingText[index])
                                .font(.headline)
                                .fontWeight(.heavy)
                                .foregroundStyle(Color.launch.tint)
                                .offset(y: counter == index ? -5 : 0)
                        }
                    }
                    .transition(.scale.animation(.easeIn))
                }
            }
            .offset(y: 70)
            
        }
        .onAppear {
            showLoadingText = true
        }
        .onReceive(timer) { _ in
            withAnimation(.spring()) {
                let lastIndex = loadingText.count - 1
                if counter == lastIndex {
                    counter = 0
                    loops += 1
                    if loops >= 2 {
                        showLaunchView = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            GoToProfileToolTip.needToShow = true
                        }
                    }
                } else {
                    counter += 1
                }
            }
        }
        
    }
}

#Preview {
    LaunchView(showLaunchView: .constant(true))
}
