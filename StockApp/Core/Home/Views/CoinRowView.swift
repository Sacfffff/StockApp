//
//  CoinRowView.swift
//  StockApp
//
//  Created by Alexandra Kravtsova on 23.10.23.
//

import SwiftUI

struct CoinRowView: View {
    
    let coin: CoinModel
    let showHoldingsColumn: Bool
    
    var body: some View {
        
        HStack(spacing: 0) {
            leftColumn
            Spacer()
            
            if showHoldingsColumn {
                centerColumn
            }
            
            rightColumn
        }
        .font(.subheadline)
        .listRowSeparator(.visible, edges: .bottom)
        .alignmentGuide(.listRowSeparatorLeading) { viewDimension in
            return viewDimension[.listRowSeparatorLeading]
        }
        .alignmentGuide(.listRowSeparatorTrailing) { viewDimension in
            return viewDimension[.trailing]
        }
    }
}

struct CoinRowView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            CoinRowView(coin: dev.coin, showHoldingsColumn: true)
                .previewLayout(.sizeThatFits)
        }
    }
    
}


private extension CoinRowView {
    
    var leftColumn: some View {
        
        HStack(spacing: 0) {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(.theme.secondaryText)
                .frame(minWidth: 30)
            Circle()
                .frame(width: 30, height: 30)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading, 6)
                .foregroundColor(.theme.tint)
        }
        
    }
    
    var centerColumn: some View {
        
        VStack(alignment: .trailing) {
            Text(coin.currentHoldingsValue.asCurrencyDecimals2)
                .bold()
            Text((coin.currentHoldings ?? 0).asNumberString)
        }
        .foregroundColor(.theme.tint)
        
    }
    
    var rightColumn: some View {
        
        VStack(alignment: .trailing) {
            Text(coin.currentPrice.asCurrencyDecimals6)
                .bold()
                .foregroundColor(.theme.tint)
            Text(coin.priceChangePercentage24H?.asPercentString ?? "")
                .foregroundColor((coin.priceChangePercentage24H ?? 0) >= 0 ? .theme.green : .theme.red)
        }
        .padding(.trailing, 6)
        .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
        
    }
    
}
