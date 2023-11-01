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
       
        if #available(iOS 17.0, *) {
            ContentUnavailableView(label: {
                Text("Oops... someting went wrong")
                    .font(.headline)
                    .foregroundColor(.theme.red)
            }, actions:  {
                Button {
                    viewModel.refreshModels()
                } label: {
                    HStack {
                        Text("Please try again")
                            .font(.subheadline)
                        Image(systemName: "repeat")
                            .font(.subheadline)
                    }
                }
            })
            .foregroundColor(.theme.tint)
        } else {
            VStack(spacing: 10) {
                Text("Oops... someting went wrong")
                    .font(.headline)
                    .foregroundColor(.theme.red)
                Button {
                    viewModel.refreshModels()
                } label: {
                    HStack {
                        Text("Please try again")
                            .font(.subheadline)
                        Image(systemName: "repeat")
                            .font(.subheadline)
                    }
                }
            }
            .foregroundColor(.theme.tint)
        }
        
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView()
            .environmentObject(dev.homeViewModel)
    }
}
