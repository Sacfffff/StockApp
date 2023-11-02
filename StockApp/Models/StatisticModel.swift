//
//  StatisticModel.swift
//  StockApp
//
//  Created by Alexandra Kravtsova on 2.11.23.
//

import Foundation

struct StatisticModel: Identifiable {
    
    let id: String = UUID().uuidString
    let title: String
    let value: String
    let percentageChange: Double?
    
    init(title: String, value: String, percentageChange: Double? = nil) {
        
        self.title = title
        self.value = value
        self.percentageChange = percentageChange
        
    }
    
}
