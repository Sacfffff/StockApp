//
//  StatisticView.swift
//  StockApp
//
//  Created by Alexandra Kravtsova on 2.11.23.
//

import SwiftUI

struct StatisticView: View {
    
    let stat: StatisticModel
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 4) {
            Text(stat.title)
                .foregroundStyle(Color.theme.secondaryText)
            Text(stat.value)
                .font(.headline)
                .foregroundStyle(Color.theme.tint)
            
            HStack(spacing: 4) {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(Angle(degrees: (stat.percentageChange ?? 0) >= 0 ? 0 : 180))
                Text(stat.percentageChange?.asPercentString ?? "")
                    .bold()
            }
            .foregroundStyle((stat.percentageChange ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
            .opacity(stat.percentageChange == nil ? 0.0 : 1.0)
        }
        .font(.caption)
        
    }
    
}

#Preview {
        StatisticView(stat: DeveloperPreview.instance.statThree)
            .previewLayout(.sizeThatFits)
}
