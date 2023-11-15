//
//  DetailViewModel.swift
//  StockApp
//
//  Created by Alexandra Kravtsova on 14.11.23.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    
    @Published var overviewStatistics: [StatisticModel] = []
    @Published var additionalStatistics: [StatisticModel] = []
    @Published var coin: CoinModel
    
    private let coinDetailService: CoinDetailDataService
    private var cancelBag: Set<AnyCancellable> = []
    
    
    init(coin: CoinModel) {
        
        self.coin = coin
        self.coinDetailService = CoinDetailDataService(coin: coin)
        setup()
        
    }
    
    
    private func setup() {
        
        coinDetailService.$coinDetail
            .combineLatest($coin)
            .map { return ( $1.asOverviewStatistics, $0?.asAdditionalStatistics(with: $1) ?? []) }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] overview, additional in
                self?.overviewStatistics = overview
                self?.additionalStatistics = additional
            }
            .store(in: &cancelBag)
        
    }
    
}


fileprivate extension CoinDetailModel {
    
    func asAdditionalStatistics(with coin: CoinModel) -> [StatisticModel] {
        
        let highStat = StatisticModel(title: "24h High",
                                      value: coin.high24H?.asCurrencyDecimals6 ?? "n/a")
        let lowStat = StatisticModel(title: "24h Low",
                                     value: coin.low24H?.asCurrencyDecimals6 ?? "n/a")
        let priceChangeStat = StatisticModel(title: "24h Price Change",
                                             value: coin.priceChange24H?.asCurrencyDecimals6 ?? "n/a",
                                             percentageChange: coin.priceChangePercentage24H)
        let marketCapChangeStat = StatisticModel(title: "24h Market Cap Change",
                                                 value: coin.marketCapChange24H?.withAbbreviations ?? "n/a",
                                                 percentageChange: coin.marketCapChangePercentage24H)
        let blockTimeStat = StatisticModel(title: "Block Time",
                                           value: self.blockTimeInMinutes == nil ? "n/a" : "\(self.blockTimeInMinutes ?? 0)")
        let hashingStat = StatisticModel(title: "Hashing Algorithm",
                                         value: self.hashingAlgorithm ?? "n/a")
        
        return [highStat, lowStat, priceChangeStat, marketCapChangeStat, blockTimeStat, hashingStat]
        
    }
    
}


fileprivate extension CoinModel {
    
    var asOverviewStatistics: [StatisticModel] {
        
        let pricePercentStat = StatisticModel(title: "Current Price",
                                       value: self.currentPrice?.asCurrencyDecimals6 ?? "",
                                       percentageChange: self.priceChangePercentage24H)
        let marketCapStat = StatisticModel(title: "Market Capitalization",
                                           value: "$\(self.marketCap?.withAbbreviations ?? "")",
                                           percentageChange: self.marketCapChangePercentage24H)
        let rankStat = StatisticModel(title: "Rank",
                                      value: "\(self.rank)")
        let volumeStat = StatisticModel(title: "Volume",
                                        value: "$\(self.totalVolume?.withAbbreviations ?? "")")
        
        return [pricePercentStat, marketCapStat, rankStat, volumeStat]
        
    }
    
}
