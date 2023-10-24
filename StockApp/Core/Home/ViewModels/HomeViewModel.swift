//
//  HomeViewModel.swift
//  StockApp
//
//  Created by Alexandra Kravtsova on 24.10.23.
//

import Foundation

class HomeViewModel: ObservableObject {
    
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    
    @Published var hasMoreResults: Bool = true
    @Published var paginationState: PaginationState = .loading
    
    private var isLoading: Bool = false
    private var page: Int = 1
    private var numberOfItemsToLoadPerPage: Int = 50
    
    init() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.allCoins.append(DeveloperPreview.instance.coin)
            self?.portfolioCoins.append(DeveloperPreview.instance.coin)
        }
        
    }
    
}


extension HomeViewModel {
    
    enum PaginationState {
        
        case loading
        case error(_ error: Error)
        case idle
        
    }
    
}
