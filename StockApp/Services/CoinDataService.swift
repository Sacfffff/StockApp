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
    private let numberOfItemsToLoadPerPage: Int = 250
    
    private var coinSubscription: AnyCancellable? = nil
    private let localDataManager = LocalNetworkingManager.shared
    
    init() {
        performFetchCoins()
    }
    
    
    private func performFetchCoins() {
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=\(numberOfItemsToLoadPerPage)&page=\(page)&sparkline=true&price_change_percentage=24h") else { return }
        
        if !isLoading, hasMoreResults, error == nil {
            isLoading = true
            
            let initialModelsLoading: Bool = page == 1
            coinSubscription = NetworkingManager.download(url: url)
                .decode(type: [CoinModel].self, decoder: JSONDecoder())
                .sink { [weak self] completion in
                    if case .failure(let error) = completion {
                        let localCoins: [CoinModel]? = self?.localDataManager.read(from: .coinModels)
                        if initialModelsLoading, let localCoins {
                            self?.modelsDidLoad(coins: localCoins, isLocalModels: true)
                        } else {
                            self?.modelsDidLoad(error: error)
                        }
                    }
                } receiveValue: { [weak self] coins in
                    self?.modelsDidLoad(coins: coins)
                    if initialModelsLoading {
                        self?.localDataManager.write(data: coins, to: .coinModels)
                    }
                    self?.coinSubscription?.cancel()
                }
        }
        
    }
    
    
    private func modelsDidLoad(coins: [CoinModel]? = nil, error: Error? = nil, isLocalModels: Bool = false) {
        
        if let error {
            self.error = error
        } else if let coins {
            allCoins.merge(newModel: coins)
            page = isLocalModels ? page : page + 1
            hasMoreResults = !coins.isEmpty && !isLocalModels
        }
        
        isLoading = false
        
    }
    
}


extension CoinDataService {
    
    func getMoreCoins() {
        performFetchCoins()
    }
    
    
    func performUpdate(forceReload: Bool = false) {
        
        if forceReload {
            page = 1
        }
        error = nil
        allCoins = []
        hasMoreResults = true
        getMoreCoins()
        
    }
    
}

fileprivate extension Array where Element == CoinModel {
    
    mutating func merge(newModel: [CoinModel]) {
        
        self.append(contentsOf: newModel.reduce(into: []) { partialResult, coin in
            if !self.contains(where: { coin.id == $0.id }) {
                partialResult.append(coin)
            }
        })
        
    }
}
