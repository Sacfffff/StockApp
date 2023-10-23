//
//  Double.swift
//  StockApp
//
//  Created by Alexandra Kravtsova on 23.10.23.
//

import Foundation

extension Double {
    
    /// Converts a Double into a Currency as a string with 2-6 decimal places
    /// ```
    /// Convert 1234.56 to "$1.234.56"
    /// Convert 12.3456 to "$12.3456"
    /// Convert 0.123456 to "$0.123456"
    /// `
    var asCurrencyDecimals6: String {
        
        return currencyFormatter6.string(from: .init(value: self)) ?? "$0.00"
    }
    
    /// Converts a Double into a string representation
    /// ```
    /// Convert 1.23456 to "1.23"
    /// `
    var asNumberString: String {
        
        return String(format: "%.2f", self)
    }
    
    /// Converts a Double into a string representation with percent symbol
    /// ```
    /// Convert 1.23456 to "1.23%"
    /// `
    var asPercentString: String {
        
        return asNumberString + "%"
    }
    
    /// Converts a Double into a Currency as a string with 2 decimal places
    /// ```
    /// Convert 1234.56 to "$1.234.56"
    /// `
    var asCurrencyDecimals2: String {
        
        return currencyFormatter2.string(from: .init(value: self)) ?? "$0.00"
    }
    
    
}


private extension Double {
    
    /// Converts a Double into a Currency with 2-6 decimal places
    /// ```
    /// Convert 1234.56 to $1.234.56
    /// Convert 12.3456 to $12.3456
    /// Convert 0.123456 to $0.123456
    /// ```
    var currencyFormatter6: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
//        formatter.locale = .current <- default value
//        formatter.currencyCode = "usd" <- change currency
//        formatter.currencySymbol = "$" <- change currency symbol
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        return formatter
    }
    
    /// Converts a Double into a Currency with 2 decimal places
    /// ```
    /// Convert 1234.56 to $1.234.56
    /// ```
    var currencyFormatter2: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
//        formatter.locale = .current <- default value
//        formatter.currencyCode = "usd" <- change currency
//        formatter.currencySymbol = "$" <- change currency symbol
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
}

