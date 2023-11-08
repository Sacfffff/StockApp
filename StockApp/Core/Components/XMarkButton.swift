//
//  XMarkButton.swift
//  StockApp
//
//  Created by Alexandra Kravtsova on 3.11.23.
//

import SwiftUI

struct XMarkButton: View {
    
    @Environment(\.dismiss) private var dismissScreen
    
    var body: some View {
        Button(action: {
            dismissScreen()
        }, label: {
            Image(systemName: "xmark")
                .font(.headline)
        })
    }
}

#Preview {
    XMarkButton()
}
