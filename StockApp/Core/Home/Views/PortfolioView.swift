//
//  PortfolioView.swift
//  StockApp
//
//  Created by Alexandra Kravtsova on 3.11.23.
//

import SwiftUI

struct PortfolioView: View {

    @EnvironmentObject private var viewModel: HomeViewModel
    @State private var selectedCoin: CoinModel? = nil
    @State private var quantityText: String = ""
    @State private var showCheckmark: Bool = false
    
    var body: some View {
        
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                        SearchBarView(searchText: $viewModel.searchText)
                        coinLogoList
                    
                    if selectedCoin != nil {
                        portfolioInputSection
                    }
                }
                .navigationTitle("Edit Portfolio")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        XMarkButton()
                    }
                    
                    ToolbarItem(placement: .topBarLeading) {
                       leadingTopBarButton
                    }
            }
                
            }
            
        }
        
    }
    
}


private extension PortfolioView {
    
    func getCurrentValue() -> Double {
        
        guard let quantity = Double(quantityText) else { return 0.0 }
        
        return quantity * (selectedCoin?.currentPrice ?? 0)
        
    }
    
    
    func saveButtonPressed() {
        
        guard let selectedCoin else { return }
        
        withAnimation(.easeIn) {
            showCheckmark = true
            removeSelectedCoin()
        }
        
        UIApplication.shared.endEditing()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            withAnimation(.easeOut) {
                showCheckmark = false
            }
        }
        
    }
    
    
    func removeSelectedCoin() {
        
        selectedCoin = nil
        viewModel.searchText = ""
        
    }
    
    
    var coinLogoList: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            
            LazyHStack(alignment: .top, spacing: 10) {
                ForEach(viewModel.searchText.isEmpty ? viewModel.allCoins : viewModel.filteredCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(6)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                selectedCoin = coin
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedCoin?.id == coin.id ? Color.theme.green : Color.clear, lineWidth: 1.0)
                        )
                }
            }
            .padding(.vertical, 6)
            .padding(.leading)
        }
        
    }
    
    var portfolioInputSection: some View {
        
        VStack(spacing: 20) {
            
            HStack {
                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""):")
                Spacer()
                Text(selectedCoin?.currentPrice?.asCurrencyDecimals6 ?? "")
            }
            
            Divider()
            
            HStack {
                Text("Amount holding:")
                Spacer()
                TextField("Ex: 1..4", text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            
            Divider()
            
            HStack {
                Text("Current value:")
                Spacer()
                Text(getCurrentValue().asCurrencyDecimals2)
            }
            
        }
        .animation(.none, value: UUID())
        .padding()
        .font(.headline)
        
    }
    
    var leadingTopBarButton: some View {
        
        HStack(spacing: 10) {
            Button {
                saveButtonPressed()
            } label: {
                Text("Save".uppercased())
            }
            .opacity(selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText) ? 1.0 : 0.0)
            
            Image(systemName: "checkmark")
                 .opacity(showCheckmark ? 1.0 : 0.0)

        }
        .font(.headline)
        
    }
    
}

#Preview {
    PortfolioView()
        .environmentObject(DeveloperPreview.instance.homeViewModel)
}
