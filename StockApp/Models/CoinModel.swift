//
//  CoinModel.swift
//  StockApp
//
//  Created by Alexandra Kravtsova on 19.10.23.
//

import Foundation

struct CoinModel: Identifiable, Codable {
    
    let id, symbol, name: String
    let image: String
    let currentPrice: Double?
    let marketCap, marketCapRank, fullyDilutedValuation: Double?
    let totalVolume, high24H, low24H: Double?
    let priceChange24H, priceChangePercentage24H: Double?
    let marketCapChange24H: Double?
    let marketCapChangePercentage24H: Double?
    let circulatingSupply, totalSupply, maxSupply, ath: Double?
    let athChangePercentage: Double?
    let athDate: String?
    let atl, atlChangePercentage: Double?
    let atlDate: String?
    let lastUpdated: String?
    let sparklineIn7D: SparklineIn7D?
    
    var currentHoldings: Double? = nil
    
    enum CodingKeys: String, CodingKey {
        
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case fullyDilutedValuation = "fully_diluted_valuation"
        case totalVolume = "total_volume"
        case high24H = "high_24h"
        case low24H = "low_24h"
        case priceChange24H = "price_change_24h"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case marketCapChange24H = "market_cap_change_24h"
        case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case ath
        case athChangePercentage = "ath_change_percentage"
        case athDate = "ath_date"
        case atl
        case atlChangePercentage = "atl_change_percentage"
        case atlDate = "atl_date"
        case lastUpdated = "last_updated"
        case sparklineIn7D = "sparkline_in_7d"
        
    }
    
}

struct SparklineIn7D: Codable {
    
    let price: [Double]?
    
}


extension CoinModel {
    
    var rank: Int {
        
        return Int(marketCapRank ?? 0)
    }
    
    var currentHoldingsValue: Double {
        
        return (currentHoldings ?? 0) * (currentPrice ?? 0)
    }
    
    
    func updateHoldings(amount: Double) -> CoinModel {
        
        return CoinModel(id: self.id, symbol: self.symbol, name: self.name, image: self.image, currentPrice: self.currentPrice, marketCap: self.marketCap, marketCapRank: self.marketCapRank, fullyDilutedValuation: self.fullyDilutedValuation, totalVolume: self.totalVolume, high24H: self.high24H, low24H: self.low24H, priceChange24H: self.priceChange24H, priceChangePercentage24H: self.priceChangePercentage24H, marketCapChange24H: self.marketCapChange24H, marketCapChangePercentage24H: self.marketCapChangePercentage24H, circulatingSupply: self.circulatingSupply, totalSupply: self.totalSupply, maxSupply: self.maxSupply, ath: self.ath, athChangePercentage: self.athChangePercentage, athDate: self.athDate, atl: self.atl, atlChangePercentage: self.atlChangePercentage, atlDate: self.atlDate, lastUpdated: self.lastUpdated, sparklineIn7D: self.sparklineIn7D, currentHoldings: amount)
        
    }
    
}
