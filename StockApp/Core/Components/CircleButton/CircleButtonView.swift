//
//  CircleButtonView.swift
//  StockApp
//
//  Created by Alexandra Kravtsova on 19.10.23.
//

import SwiftUI

struct CircleButtonView: View {
    
    let iconName: String
    
    var body: some View {
       
        Image(systemName: iconName)
            .font(.headline)
            .foregroundStyle(Color.theme.tint)
            .frame(width: 50, height: 50)
            .background(
                Circle()
                    .foregroundStyle(Color.theme.background)
            )
            .shadow(color: .theme.tint.opacity(0.25), radius: 10, x: 0, y: 0)
            .padding()
        
    }
}

struct CircleButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CircleButtonView(iconName: "heart.fill")
            .previewLayout(.sizeThatFits)
    }
}
