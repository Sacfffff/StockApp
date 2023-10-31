//
//  UIApplication.swift
//  StockApp
//
//  Created by Alexandra Kravtsova on 31.10.23.
//

import SwiftUI

extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
