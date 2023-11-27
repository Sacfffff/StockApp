//
//  HomeView.swift
//  StockApp
//
//  Created by Alexandra Kravtsova on 19.10.23.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    
    @EnvironmentObject private var viewModel: HomeViewModel
    @State private var showPortfolio: Bool = false
    @State private var showPortfolioSheet: Bool = false
    @State private var showSettingView: Bool = false
    
    var body: some View {
        
        ZStack {
            Color.theme.background.ignoresSafeArea()
            
            
            VStack {
                homeHeader
                HomeStatsView(showPortfolio: $showPortfolio)
                SearchBarView(searchText: $viewModel.searchText)
                
                columnTitles
                
                if !showPortfolio {
                    coinsList
                        .transition(.move(edge: .leading))
                } else {
                    ZStack(alignment: .top) {
                        if viewModel.savedPortfolios.isEmpty && viewModel.searchText.isEmpty {
                            portfolioEmptyText
                        } else {
                            portfolioCoinsList
                        }
                    }
                    .transition(.move(edge: .trailing))
                }
                
                Spacer(minLength: 0)
            }
            .sheet(isPresented: $showSettingView) {
                SettingsView()
            }
            .sheet(isPresented: $showPortfolioSheet) {
                PortfolioView()
                    .environmentObject(viewModel)
            }
            
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HomeView()
                .toolbar(.hidden)
        }
        .environmentObject(dev.homeViewModel)
    }
}


private extension HomeView {
    
    var homeHeader: some View {
        
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .animation(.none, value: showPortfolio)
                .onTapGesture {
                    if showPortfolio {
                        showPortfolioSheet.toggle()
                    } else {
                        showSettingView.toggle()
                    }
                }
                .background(
                    CircleButtonAnimationView(animate: $showPortfolio)
                )
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundStyle(Color.theme.tint)
                .animation(.none)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(.degrees(showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
        
    }
    
    var coinsList: some View {
        
        List {
            ForEach(viewModel.searchText.isEmpty ? viewModel.allCoins : viewModel.filteredCoins) { coin in
                    CoinRowView(coin: coin, showHoldingsColumn: false)
                        .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
                        .background(
                            NavigationLink(value: coin) { EmptyView() }.opacity(0.0)
                        )
            }
            if viewModel.hasMoreResults, viewModel.searchText.isEmpty {
                PaginationRowView()
            }
        }
        .id(UUID())
        .navigationDestination(for: CoinModel.self) { coin in
            DetailView(coin: coin)
        }
        .scrollIndicators(.hidden)
        .scrollContentBackground(.hidden)
        .listStyle(.plain)
        
    }
    
    var portfolioCoinsList: some View {
        
        List {
            ForEach(viewModel.savedPortfolios) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
                    .background(
                        NavigationLink(value: coin) { EmptyView() }.opacity(0.0)
                    )
            }
        }
        .id(UUID())
        .navigationDestination(for: CoinModel.self) { coin in
            DetailView(coin: coin)
        }
        .scrollIndicators(.hidden)
        .scrollContentBackground(.hidden)
        .listStyle(.plain)
        .refreshable {
            viewModel.reloadData()
        }
        
    }
    
    var portfolioEmptyText: some View {
        
        Text("You haven`t added any coins to your portfolio. Click the + button to get started! 🧐")
            .font(.callout)
            .foregroundStyle(Color.theme.tint)
            .fontWeight(.medium)
            .multilineTextAlignment(.center)
            .padding(50)
        
    }
    
    var columnTitles: some View {
        
        HStack {
            HStack(spacing: 4) {
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity(viewModel.sortOption == .rank || viewModel.sortOption == .rankReverced ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: viewModel.sortOption == .rank ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    viewModel.sortOption = viewModel.sortOption == .rank ? .rankReverced : .rank
                }
            }
            
            Spacer()
            
            if showPortfolio {
                HStack(spacing: 4) {
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity(viewModel.sortOption == .holdings || viewModel.sortOption == .holdingsReverse ? 1.0 : 0.0)
                        .rotationEffect(Angle(degrees: viewModel.sortOption == .holdings ? 0 : 180))
                }
                .onTapGesture {
                    withAnimation(.default) {
                        viewModel.sortOption = viewModel.sortOption == .holdings ? .holdingsReverse : .holdings
                    }
                }
            }
            
            HStack(spacing: 4) {
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity(viewModel.sortOption == .price || viewModel.sortOption == .priceReversed ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: viewModel.sortOption == .price ? 0 : 180))
            }
            .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
            .onTapGesture {
                withAnimation(.default) {
                    viewModel.sortOption = viewModel.sortOption == .price ? .priceReversed : .price
                }
            }
        }
        .font(.caption)
        .foregroundStyle(Color.theme.secondaryText)
        .padding(.horizontal)
        
    }
    
}
