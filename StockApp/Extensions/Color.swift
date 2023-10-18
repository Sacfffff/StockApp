//
//  Color.swift
//  StockApp
//
//  Created by Alexandra Kravtsova on 18.10.23.
//

import SwiftUI

extension Color {
    
   static let theme = ColorTheme()
    
}

struct ColorTheme {
    
    let tint = Color("AccentColor")
    let background = Color("BackgroundColor")
    let green = Color("GreenColor")
    let red = Color("RedColor")
    let secondaryText = Color("SecondaryTextColor")
    
}
