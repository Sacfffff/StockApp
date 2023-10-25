//
//  CoinDataService.swift
//  StockApp
//
//  Created by Alexandra Kravtsova on 25.10.23.
//

import Foundation
import Combine

class CoinDataService {
    
    @Published var allCoins: [CoinModel] = []
    @Published var hasMoreResults: Bool = true
    @Published var error: Error? = nil
    
    private var isLoading: Bool = false
    private var page: Int = 1
    private var numberOfItemsToLoadPerPage: Int = 250
    
    private var coinSubscription: AnyCancellable? = nil
    
    init() {
        performFetchCoins()
    }
    
    
    private func performFetchCoins() {
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=\(numberOfItemsToLoadPerPage)&page=\(page)&sparkline=true&price_change_percentage=24h") else { return }
        
        if !isLoading, hasMoreResults, error == nil {
            isLoading = true
            
           coinSubscription = URLSession.shared.dataTaskPublisher(for: url)
                .subscribe(on: DispatchQueue.global(qos: .default))
                .tryMap { output in
                    guard let responce = output.response as? HTTPURLResponse, 200...299 ~= responce.statusCode else {
                        throw URLError.init(.badServerResponse)
                    }
                    return output.data
                }
                .receive(on: DispatchQueue.main)
                .decode(type: [CoinModel].self, decoder: JSONDecoder())
                .sink { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.modelsDidLoad(error: error)
                    }
                } receiveValue: { [weak self] coins in
                    self?.modelsDidLoad(coins: coins)
                }
        }
        
    }
    
    
    private func modelsDidLoad(coins: [CoinModel]? = nil, error: Error? = nil) {
        
        if let error {
            allCoins = []
            self.error = error
        } else if let coins {
            page += 1
            hasMoreResults = false//!coins.isEmpty
            allCoins = coins
        }
        
        isLoading = false
        
    }
    
}


extension CoinDataService {
    
    func getMoreCoins() {
        performFetchCoins()
    }
    
    
    func performUpdate() {
        
        error = nil
        allCoins = []
        hasMoreResults = true
        getMoreCoins()
        
    }
    
}
