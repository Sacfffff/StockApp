//
//  DetailView.swift
//  StockApp
//
//  Created by Alexandra Kravtsova on 13.11.23.
//

import SwiftUI

struct DetailView: View {
    
    @StateObject private var viewModel: DetailViewModel
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    private let spacing: CGFloat = 40
    
    init(coin: CoinModel) {
        
        self._viewModel = .init(wrappedValue: .init(coin: coin))
        
    }
    
    var body: some View {
        ScrollView {
            
            VStack {
                ChartView(coin: viewModel.coin)
                    .padding(.vertical)
                
                VStack(spacing: 20) {
                    
                    overviewTitle
                    Divider()
                    overviewGrid
                    
                    additionalTitle
                    Divider()
                    additionalGrid
                    
                }
                .padding()
            }
            
          
        }
        .navigationTitle(viewModel.coin.name)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                topBarTrailingContent
            }
        }
    }
}

#Preview {
    NavigationStack {
        DetailView(coin: DeveloperPreview.instance.coin)
    }
}


private extension DetailView {
    
    var overviewTitle: some View {
        
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundStyle(Color.theme.tint)
            .frame(maxWidth: .infinity, alignment: .leading)
        
    }
    
    var overviewGrid: some View {
        
        LazyVGrid(columns: columns, alignment: .leading, spacing: spacing, pinnedViews: [], content: {
            ForEach(viewModel.overviewStatistics) { stat in
                StatisticView(stat: stat)
            }
        })
        
    }
    
    var additionalTitle: some View {
        
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundStyle(Color.theme.tint)
            .frame(maxWidth: .infinity, alignment: .leading)
        
    }
    
    var additionalGrid: some View {
        
        LazyVGrid(columns: columns, alignment: .leading, spacing: spacing, pinnedViews: [], content: {
            ForEach(viewModel.additionalStatistics) { stat in
                StatisticView(stat: stat)
            }
        })
        
    }
    
    var topBarTrailingContent: some View {
        
        HStack {
            Text(viewModel.coin.symbol.uppercased())
                .font(.headline)
            .foregroundStyle(Color.theme.secondaryText)
            
            CoinImageView(coin: viewModel.coin)
                .frame(width: 25, height: 25)
            
        }
        
    }
    
}
