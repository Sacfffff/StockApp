//
//  MarketDataService.swift
//  StockApp
//
//  Created by Alexandra Kravtsova on 3.11.23.
//

import Foundation
import Combine

class MarketDataService {
    
    @Published var marketData: MarketDataModel? = nil
    
    private var marketDataSubscription: AnyCancellable? = nil
    private let localDataManager = LocalNetworkingManager.shared
    
    init() {
        
        performFetchMarketData()
        
    }
    
    
    func performFetchMarketData() {
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return }
        
        marketDataSubscription = NetworkingManager.download(url: url)
                .decode(type: GlobalData.self, decoder: JSONDecoder())
                .sink { [weak self] completion in
                    if case .failure(_) = completion {
                        self?.marketData = self?.localDataManager.read(from: .marketData)
                    }
                } receiveValue: { [weak self] marketData in
                    self?.marketData = marketData.data
                    self?.localDataManager.write(data: marketData.data, to: .marketData)
                    self?.marketDataSubscription?.cancel()
                }
        
    }
    
}

