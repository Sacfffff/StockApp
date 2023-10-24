//
//  PaginationRow.swift
//  StockApp
//
//  Created by Alexandra Kravtsova on 24.10.23.
//

import SwiftUI

struct PaginationRowView: View {
    
    @EnvironmentObject private var viewModel: HomeViewModel
    
    var body: some View {
        
        ZStack {
            switch viewModel.paginationState {
                case .loading:
                    ProgressView()
                case .idle:
                    EmptyView()
                case .error:
                    fatalError()
            }
        }
        .listRowSeparatorTint(.clear)
        .frame(height: 50)
        .frame(maxWidth: .infinity)
        .onAppear {
            //viewModel.loadMoreItems()
        }
        
    }
}

struct PaginationRow_Previews: PreviewProvider {
    static var previews: some View {
        PaginationRowView()
            .frame(height: 50)
            .previewLayout(.sizeThatFits)
            .environmentObject(dev.homeViewModel)
    }
}
