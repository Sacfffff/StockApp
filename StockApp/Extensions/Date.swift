//
//  Date.swift
//  StockApp
//
//  Created by Alexandra Kravtsova on 20.11.23.
//

import Foundation

extension Date {
    
    private static var coinGeckoFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }
    
    
    private var shortFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    
    init(coinGeckoString: String) {
        
        let date = Self.coinGeckoFormatter.date(from: coinGeckoString) ?? .now
        self.init(timeInterval: 0, since: date)
        
    }
    
    func asShortDateString() -> String {
        return shortFormatter.string(from: self)
    }
    
}
