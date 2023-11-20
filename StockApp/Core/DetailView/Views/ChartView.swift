//
//  ChartView.swift
//  StockApp
//
//  Created by Alexandra Kravtsova on 20.11.23.
//

import SwiftUI

struct ChartView: View {
    
    @State private var percentage: CGFloat = 0
    
    private let data: [Double]
    private let maxY: Double
    private let minY: Double
    
    private let lineColor: Color
    private let startingDate: Date
    private let endingDate: Date
    
    init(coin: CoinModel) {
        
        self.data = coin.sparklineIn7D?.price ?? []
        maxY = data.max() ?? 0.0
        minY = data.min() ?? 0.0
        
        let priceChange = (data.last ?? 0.0) - (data.first ?? 0.0)
        lineColor = priceChange >= 0 ? .theme.green : .theme.red
        
        endingDate = Date(coinGeckoString: coin.lastUpdated ?? "")
        let sevenDayInSeconds: Double = 7*24*60*60
        startingDate = endingDate.addingTimeInterval(-sevenDayInSeconds)
        
    }
    
    var body: some View {
        
        VStack {
            
            chartView
                .frame(height: 200)
                .background(
                    chartBackgroung
                )
                .overlay(alignment: .leading) {
                    chartOverlay
                        .padding(.horizontal, 4)
                }
            
            chartDateLabels
                .padding(.horizontal, 4)
            
        }
        .font(.caption)
        .foregroundStyle(Color.theme.secondaryText)
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.linear(duration: 2.0)) {
                    percentage = 1.0
                }
            }
        }
        
    }
    
}

#Preview {
    ChartView(coin: DeveloperPreview.instance.coin)
}

private extension ChartView {
    
    var chartView: some View {
        
        GeometryReader { proxy in
            Path { path in
                for index in data.indices {
                    let xPosition = proxy.size.width / CGFloat(data.count) * (CGFloat(index) + 1)
                    let yAxis = maxY - minY
                    let yPosition = (1 - CGFloat((data[index] - minY) / yAxis)) * proxy.size.height
                    
                    if index == 0 {
                        path.move(to: .init(x: xPosition, y: yPosition))
                    }
                    path.addLine(to: .init(x: xPosition, y: yPosition))
                    
                }
                
            }
            .trim(from: 0, to: percentage)
            .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            .shadow(color: lineColor.opacity(0.5), radius: 10, x: 0.0, y: 20)
            .shadow(color: lineColor.opacity(0.2), radius: 10, x: 0.0, y: 30)
            .shadow(color: lineColor.opacity(0.1), radius: 10, x: 0.0, y: 40)
        }

        
    }
    
    var chartBackgroung: some View {
        
        VStack {
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
        
    }
    
    var chartOverlay: some View {
        
        VStack {
            Text(maxY.withAbbreviations)
            Spacer()
            let price = ((maxY + minY) / 2).withAbbreviations
            Text(price)
            Spacer()
            Text(minY.withAbbreviations)
        }
        
    }
    
    var chartDateLabels: some View {
        
        HStack {
            Text(startingDate.asShortDateString())
            Spacer()
            Text(endingDate.asShortDateString())
        }
        
    }
    
}
