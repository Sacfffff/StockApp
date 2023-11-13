//
//  DetailView.swift
//  StockApp
//
//  Created by Alexandra Kravtsova on 13.11.23.
//

import SwiftUI

struct DetailView: View {
    
    let coin: CoinModel
    
    var body: some View {
        Text(coin.id)
    }
}

#Preview {
    DetailView(coin: DeveloperPreview.instance.coin)
}
