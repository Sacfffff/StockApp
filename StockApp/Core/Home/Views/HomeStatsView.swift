//
//  HomeStatsView.swift
//  StockApp
//
//  Created by Alexandra Kravtsova on 2.11.23.
//

import SwiftUI

struct HomeStatsView: View {
    
    @EnvironmentObject private var viewModel: HomeViewModel
    @Binding var showPortfolio: Bool
    
    var body: some View {
        
        HStack {
            ForEach(viewModel.statistics) { stat in
                StatisticView(stat: stat)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        .frame(width: UIScreen.main.bounds.width, alignment: showPortfolio ? .trailing : .leading)
        
    }
    
}

#Preview {
    HomeStatsView(showPortfolio: .constant(false))
        .environmentObject(DeveloperPreview.instance.homeViewModel)
}
