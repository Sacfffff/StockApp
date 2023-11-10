//
//  PortfolioDataService.swift
//  StockApp
//
//  Created by Alexandra Kravtsova on 10.11.23.
//

import Combine
import SwiftData

class PortfolioDataService {
    
    @Published var portfolioEntities: [PortfolioEntity] = []
    
    private var modelContext: ModelContext
    
    
    init(modelContext: ModelContext) {
        
        self.modelContext = modelContext
        fetchData()
        
    }
    
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        
        if let entity = portfolioEntities.first(where: { $0.coinId == coin.id }) {
            if amount > 0 {
                entity.amount = amount
            } else {
                modelContext.delete(entity)
            }
        } else {
            insert(model: coin, amount: amount)
        }
        
        fetchData()
    
    }
    
}

//MARK: - SwiftData

private extension PortfolioDataService {
    
    
    func insert(model: CoinModel, amount: Double) {
        
        let entity = PortfolioEntity(coinId: model.id, amount: amount)
        modelContext.insert(entity)
        
    }
    
    
    private func fetchData() {
        
        let descriptor = FetchDescriptor<PortfolioEntity>()
        portfolioEntities = (try? modelContext.fetch(descriptor)) ?? []
        
    }
    
}
