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
    
    @StateObject private var viewModel: HomeViewModel
    private let container: ModelContainer
    
    @State private var showLaunchView: Bool = true
    
    init() {
        
        do {
            container = try ModelContainer(for: PortfolioEntity.self)
            let viewModel = HomeViewModel(modelContext: container.mainContext)
            _viewModel = .init(wrappedValue: viewModel)
        } catch {
            fatalError("Failed to create ModelContainer for Portfolio.")
        }
        
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.tint)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.tint)]
        
    }
    
    var body: some Scene {
        WindowGroup {
            
            ZStack {
                
                NavigationStack {
                    HomeView()
                        .toolbar(.hidden)
                }
                .environmentObject(viewModel)
                
                ZStack {
                    if showLaunchView {
                        LaunchView(showLaunchView: $showLaunchView)
                            .transition(.move(edge: .leading))
                    }
                }
                .zIndex(2.0)
                
            }
            
        }
        .modelContainer(container)
    }
    
}
