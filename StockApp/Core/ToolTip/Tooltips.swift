//
//  Tooltips.swift
//  StockApp
//
//  Created by Alexandra Kravtsova on 6.12.23.
//

import Foundation
import TipKit

struct GoToProfileToolTip: Tip {
    
    @Parameter
    static var needToShow: Bool = false
    
    var options: [Option] {
        [MaxDisplayCount(1)]
    }
    
    var title: Text {
        
        Text("Check Your Profile")
    }
    
    var message: Text? {
        
        Text("Tap here to see your profile coins or add new ones!")
    }
    
    var image: Image? {
        
        Image(systemName: "person.circle")
    }
    
    var rules: [Rule] {
        
//        #Rule(Self.needToShow) { event in
//            event.donations.count == 0
//        }
        #Rule(Self.$needToShow) { $0 == true }
        
    }
    
}
