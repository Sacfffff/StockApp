//
//  CoinImageView.swift
//  StockApp
//
//  Created by Alexandra Kravtsova on 27.10.23.
//

import SwiftUI

struct CoinImageView: View {
    
    @StateObject private var viewModel: CoinImageViewModel

    init(coin: CoinModel) {
        
        _viewModel = .init(wrappedValue: .init(coin: coin))
        
    }

    var body: some View {
      
        ZStack {
            
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else if viewModel.isLoading {
                ProgressView()
            } else {
                Image(systemName: "questionmark")
                    .foregroundColor(.theme.secondaryText)
            }
            
        }
        
    }
    
}

struct CoinImageView_Previews: PreviewProvider {
    static var previews: some View {
        CoinImageView(coin: dev.coin)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
