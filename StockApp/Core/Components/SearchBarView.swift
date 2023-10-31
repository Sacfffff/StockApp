//
//  SearchBarview.swift
//  StockApp
//
//  Created by Alexandra Kravtsova on 31.10.23.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(searchText.isEmpty ? .theme.secondaryText : .theme.tint)
            
            TextField("Search by name or symbol...", text: $searchText)
                .foregroundColor(.theme.tint)
                .autocorrectionDisabled()
                .keyboardType(.alphabet)
            
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.theme.tint)
                .opacity(searchText.isEmpty ? 0.0 : 1.0)
                .onTapGesture {
                    UIApplication.shared.endEditing()
                    searchText = ""
                }
               
        }
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.theme.background)
                .shadow(color: .theme.tint.opacity(0.15), radius: 10, x: 0, y: 0)
        )
        .padding()
    }
}

struct SearchBarview_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(searchText: .constant(""))
    }
}
