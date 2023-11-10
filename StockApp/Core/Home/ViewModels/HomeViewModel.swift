//
//  HomeViewModel.swift
//  StockApp
//
//  Created by Alexandra Kravtsova on 24.10.23.
//

import Foundation
import Combine
import SwiftData

class HomeViewModel: ObservableObject {
    
    @Published var statistics: [StatisticModel] = []
    
    @Published var allCoins: [CoinModel] = []
    @Published var filteredCoins: [CoinModel] = []
    
    @Published var searchText: String = ""
    
    @Published var paginationState: PaginationState = .loading
    @Published var hasMoreResults: Bool = true
    
    @Published var savedPortfolios: [CoinModel] = []
    
    private let portfolioDataService: PortfolioDataService
    
    private var cancelBag: Set<AnyCancellable> = []
    
    private var coinDataService = CoinDataService()
    private var marketDataService = MarketDataService()
    
    init(modelContext: ModelContext) {
        
        self.portfolioDataService = PortfolioDataService(modelContext: modelContext)
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
        
        $allCoins
            .combineLatest(portfolioDataService.$portfolioEntities, $filteredCoins)
            .map{ allCoins, portfolioEntities, filteredCoins in
                if !filteredCoins.isEmpty {
                    return filteredCoins.getCoinModelsFilteredAndUpdated(by: portfolioEntities)
                } else {
                    return allCoins.getCoinModelsFilteredAndUpdated(by: portfolioEntities)
                }
            }
            .sink { [weak self] savedPortfolios in
                self?.savedPortfolios = savedPortfolios
            }
            .store(in: &cancelBag)
        
        marketDataService.$marketData
            .combineLatest($savedPortfolios)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] marketData, portfolioCoins in
                self?.statistics = marketData?.getStatisticModels(with: portfolioCoins) ?? []
            }
            .store(in: &cancelBag)
        
    }
    
    
    private func updateState() {
        
        if coinDataService.allCoins.isEmpty {
            paginationState = updatePaginationState()
        } else {
            allCoins = coinDataService.allCoins
            paginationState = updatePaginationState()
        }
        
    }
    
    
    private func updatePaginationState() -> PaginationState {
        
        var result: PaginationState = .loading
        
        if let error = coinDataService.error {
            result = .error(error)
            print(error.localizedDescription)
        } else if coinDataService.hasMoreResults == false {
            result = .idle
        }
        
        return result
        
    }
    
}


extension HomeViewModel {
    
    func getMoreModels() {
        
        coinDataService.getMoreCoins()
        
    }
    
    
    func refreshModels() {
        
        coinDataService.performUpdate()
        
    }
    
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    
    }
    
    
    func reloadData() {
        
        coinDataService.performUpdate(forceReload: true)
        marketDataService.performFetchMarketData()
        
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
    
    func getStatisticModels(with portfolioCoins: [CoinModel]) -> [StatisticModel] {
        
        let marketCap: StatisticModel = .init(title: "Market Cap", value: self.marketCap, percentageChange: self.marketCapChangePercentage24HUsd)
        let volume: StatisticModel = .init(title: "24h Volume", value: self.volume)
        let btcDominance: StatisticModel = .init(title: "BTC Dominance", value: self.btcDominance)
        
        let sumOfCurrentPortfolioValues = portfolioCoins.map{ $0.currentHoldingsValue }.reduce(0.0, +)
        let sumOfPrevPortfolioValues = portfolioCoins.reduce(into: 0.0) { prevResult, coin in
            let currentValue = coin.currentHoldingsValue
            let percentChange = (coin.priceChangePercentage24H ?? 0) / 100
            prevResult += currentValue / (1 + percentChange)
        }
        let percentageChange = ((sumOfCurrentPortfolioValues - sumOfPrevPortfolioValues) / sumOfPrevPortfolioValues) * 100
        
        let portfolio: StatisticModel = .init(title: "Portfolio Value", value: sumOfCurrentPortfolioValues.asCurrencyDecimals2, percentageChange: percentageChange)
        return [marketCap, volume, btcDominance, portfolio]
        
    }
    
}
