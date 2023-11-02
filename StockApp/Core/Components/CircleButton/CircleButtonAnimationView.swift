//
//  CircleButtonAnimationView.swift
//  StockApp
//
//  Created by Alexandra Kravtsova on 19.10.23.
//

import SwiftUI

struct CircleButtonAnimationView: View {
    
    @Binding var animate: Bool
    
    var body: some View {
        
        Circle()
            .stroke(lineWidth: 5.0)
            .scale(animate ? 1.0 : 0.0)
            .opacity(animate ?  0.0 : 1.0)
            .animation(animate ? .easeOut(duration: 1.0) : .none, value: animate)
    }
    
}

struct CircleButtonAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        CircleButtonAnimationView(animate: .constant(false))
            .foregroundStyle(Color.red)
            .frame(width: 100, height: 100)
    }
}
