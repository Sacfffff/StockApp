//
//  PortfolioEntity.swift
//  StockApp
//
//  Created by Alexandra Kravtsova on 8.11.23.
//

import Foundation
import SwiftData

@Model
class PortfolioEntity {
    
    let coinId: String
    var amount: Double
    
    init(coinId: String, amount: Double) {
        
        self.coinId = coinId
        self.amount = amount
        
    }
    
}
