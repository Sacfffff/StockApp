//
//  String.swift
//  StockApp
//
//  Created by Alexandra Kravtsova on 14.11.23.
//

import Foundation

extension String {
    
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
}
