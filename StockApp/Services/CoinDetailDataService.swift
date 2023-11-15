//
//  CoinDetailDataService.swift
//  StockApp
//
//  Created by Alexandra Kravtsova on 14.11.23.
//

import Foundation
import Combine

class CoinDetailDataService {
    
    @Published var coinDetail: CoinDetailModel? = nil
    
    private var coinDetailSubscription: AnyCancellable? = nil
    private let localDataManager = LocalNetworkingManager.shared
    
    init(coin: CoinModel) {
        
        performFetchCoinDetail(with: coin.id)
        
    }
    
    
    private func performFetchCoinDetail(with id: String) {
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else { return }
        
        coinDetailSubscription = NetworkingManager.download(url: url)
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
            .sink { [weak self] completion in
                if case .failure(_) = completion {
                    self?.coinDetail = self?.localDataManager.read(from: .custom(fileName: "coin_\(id)"))
                }
            } receiveValue: { [weak self] coinDetail in
                self?.coinDetail = coinDetail
                self?.localDataManager.write(data: coinDetail, to: .custom(fileName: "coin_\(id)"))
                self?.coinDetailSubscription?.cancel()
            }
        
    }
    
}
