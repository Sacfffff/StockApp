//
//  HomeViewModel.swift
//  StockApp
//
//  Created by Alexandra Kravtsova on 24.10.23.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var statistics: [StatisticModel] = []
    
    @Published var allCoins: [CoinModel] = []
    @Published var filteredCoins: [CoinModel] = []
    
    @Published var searchText: String = ""
    
    @Published var paginationState: PaginationState = .loading
    @Published var hasMoreResults: Bool = true
    
    private var cancelBag: Set<AnyCancellable> = []
    
    private var coinDataService = CoinDataService()
    private var marketDataService = MarketDataService()
    
    init() {
        
        setup()
        
    }
    
    
    private func setup() {
        
        coinDataService.$allCoins
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateState()
            }
            .store(in: &cancelBag)
        
        coinDataService.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateState()
            }
            .store(in: &cancelBag)
        
        coinDataService.$hasMoreResults
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.hasMoreResults = value
            }
            .store(in: &cancelBag)
        
        $searchText
            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                guard !text.isEmpty else {
                    self?.filteredCoins = []
                    return
                }
                self?.filteredCoins = self?.allCoins.filterCoins(by: text.lowercased()) ?? []
            }
            .store(in: &cancelBag)
        
        marketDataService.$marketData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] marketData in
                self?.statistics = marketData?.asStatisticModels ?? []
            }
            .store(in: &cancelBag)
        
    }
    
    
    private func updateState() {
        
        if coinDataService.allCoins.isEmpty {
            if let error = coinDataService.error {
                paginationState = .error(error)
                print(error.localizedDescription)
            } else if coinDataService.hasMoreResults == false {
                paginationState = .idle
            } else {
                paginationState = .loading
            }
        } else {
            allCoins.merge(newModel: coinDataService.allCoins)
        }
        
    }
    
}


extension HomeViewModel {
    
    func getMoreModels() {
        
        coinDataService.getMoreCoins()
        
    }
    
    
    func refreshModels() {
        
        coinDataService.performUpdate()
        
    }
    
    
    func getCoinModels(from entyties: [PortfolioEntity]) -> [CoinModel] {
        
        if !filteredCoins.isEmpty {
            return filteredCoins.getCoinModelsFilteredAndUpdated(by: entyties)
        } else {
            return allCoins.getCoinModelsFilteredAndUpdated(by: entyties)
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


fileprivate extension Array where Element == CoinModel {
    
    mutating func merge(newModel: [CoinModel]) {
      
        self.append(contentsOf: newModel.reduce(into: []) { partialResult, coin in
            if !self.contains(where: { coin.id == $0.id }) {
                partialResult.append(coin)
            }
        })
        
    }
    
    
    func filterCoins(by text: String) -> [CoinModel] {
        
        return self.filter{ $0.name.lowercased().contains(text) ||
            $0.symbol.lowercased().contains(text) ||
            $0.id.lowercased().contains(text)}
        
    }
    
    
    func getCoinModelsFilteredAndUpdated(by entities: [PortfolioEntity]) -> [CoinModel] {
        
        return self.reduce(into: [], { partialResult, model in
            if let entity = entities.first(where: { $0.coinId == model.id }) {
                partialResult.append(model.updateHoldings(amount: entity.amount))
            }
        })
        
    }
    
    
}

fileprivate extension MarketDataModel {
    
    var asStatisticModels: [StatisticModel] {
        
        let marketCap: StatisticModel = .init(title: "Market Cap", value: self.marketCap, percentageChange: self.marketCapChangePercentage24HUsd)
        let volume: StatisticModel = .init(title: "24h Volume", value: self.volume)
        let btcDominance: StatisticModel = .init(title: "BTC Dominance", value: self.btcDominance)
        let portfolio: StatisticModel = .init(title: "Portfolio Value", value: "$0.00", percentageChange: 0)
        return [marketCap, volume, btcDominance, portfolio]
    }
    
}
