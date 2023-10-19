//
//  StockAppApp.swift
//  StockApp
//
//  Created by Alexandra Kravtsova on 18.10.23.
//

import SwiftUI

@main
struct StockAppApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
                    .toolbar(.hidden)
            }
        }
    }
}
