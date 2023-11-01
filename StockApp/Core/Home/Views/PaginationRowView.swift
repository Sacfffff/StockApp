//
//  PaginationRow.swift
//  StockApp
//
//  Created by Alexandra Kravtsova on 24.10.23.
//

import SwiftUI

struct PaginationRowView: View {
    
    @EnvironmentObject private var viewModel: HomeViewModel
    
    var body: some View {
        
        ZStack {
            switch viewModel.paginationState {
                case .loading:
                    ActivityIndicator(isAnimating: .constant(true), style: .medium)
                case .idle:
                case .error:
                    ErrorView()
            }
        }
        .listRowSeparatorTint(.clear)
        .frame(height: 50)
        .frame(maxWidth: .infinity)
        .onAppear {
            viewModel.getMoreModels()
        }
        
    }
}

struct PaginationRow_Previews: PreviewProvider {
    static var previews: some View {
        PaginationRowView()
            .frame(height: 50)
            .previewLayout(.sizeThatFits)
            .environmentObject(dev.homeViewModel)
    }
}

// progressView temp fix
fileprivate extension PaginationRowView {
    
    struct ActivityIndicator: UIViewRepresentable {
        
        @Binding var isAnimating: Bool
        
        let style: UIActivityIndicatorView.Style
        
        
        func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
            
            return UIActivityIndicatorView(style: style)
            
        }
        
        
        func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
            
            isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
            
        }
        
    }
    
}
