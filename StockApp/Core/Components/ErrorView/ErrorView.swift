//
//  ErrorView.swift
//  StockApp
//
//  Created by Alexandra Kravtsova on 25.10.23.
//

import SwiftUI

struct ErrorView: View {
    
    @EnvironmentObject var viewModel: HomeViewModel
    
    var body: some View {
       
        VStack(spacing: 10) {
            Text("Oops... someting went wrong")
                .font(.headline)
                .foregroundColor(.theme.tint)
            Button {
                
            } label: {
                Text("Please try again")
                    .font(.subheadline)
                Image(systemName: "repeat")
                    .font(.subheadline)
            }
        }
        .foregroundColor(.theme.tint)
        
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView()
            .environmentObject(dev.homeViewModel)
    }
}
