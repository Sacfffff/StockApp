//
//  StockAppApp.swift
//  StockApp
//
//  Created by Alexandra Kravtsova on 18.10.23.
//

import SwiftUI
import SwiftData

@main
struct StockAppApp: App {
    
    @StateObject private var viewModel = HomeViewModel()
    
    init() {
        
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.tint)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.tint)]
        
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
                    .toolbar(.hidden)
            }
            .environmentObject(viewModel)
        }
        .modelContainer(for: PortfolioEntity.self)
    }
}
