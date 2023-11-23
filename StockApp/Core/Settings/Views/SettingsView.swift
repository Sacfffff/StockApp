//
//  SettingsView.swift
//  StockApp
//
//  Created by Alexandra Kravtsova on 22.11.23.
//

import SwiftUI

struct SettingsView: View {
    
    private let defaultUrl = URL(string: "https://www.google.com")
    private let coingeckoUrl = URL(string: "https://www.coingecko.com")
    let personalUrl = URL(string: "https://github.com/Sacfffff")
    
    var body: some View {
       
        NavigationStack {
            
            List {
                coingeckoSection
                developerSection
                applicationSection
            }
            .listStyle(.grouped)
            .navigationTitle("Settings")
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    XMarkButton()
                }
            }
            
        }
        
    }
}

#Preview {
    SettingsView()
}


private extension SettingsView {
    
    var coingeckoSection: some View {
        
        Section {
            VStack(alignment: .leading) {
                Image("coingecko")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("The cryptocuttency data that usen in this app comes from a free API from CoinGecko. Prices may be slightly delayed.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.theme.tint)
            }
            .padding(.vertical)
            if let coingeckoUrl {
                Link("Visit Coin Gecko 🦎", destination: coingeckoUrl)
                    .tint(.blue)
            }
        } header: {
            Text("Coin Gecko")
        }
        
    }
    
    var developerSection: some View {
        
        Section {
            VStack(alignment: .leading) {
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app was developed by Alex Kravc. It uses SwiftUI and written 100% in Swift. The project benefits from multi-threading, local file manager, publisher/subscribers and data persistance.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.theme.tint)
            }
            .padding(.vertical)
            if let personalUrl {
                Link("Visit my GitHub 🥳", destination: personalUrl)
                    .tint(.blue)
            }
        } header: {
            Text("Developer")
        }
        
    }
    
    var applicationSection: some View {
        
        Section {
            if let defaultUrl {
                Link("Terms of Service", destination: defaultUrl)
                    .tint(.blue)
                Link("Privacy Policy", destination: defaultUrl)
                    .tint(.blue)
                Link("Company Website", destination: defaultUrl)
                    .tint(.blue)
                Link("Learn more", destination: defaultUrl)
                    .tint(.blue)
            }
        } header: {
            Text("Application")
        }
        
    }
    
}
