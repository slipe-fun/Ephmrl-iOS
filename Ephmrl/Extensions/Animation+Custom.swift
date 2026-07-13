//
//  Animation+Custom.swift
//  Ephmrl
//
//  Created by Аскольд on 13.07.2026.
//

import SwiftUI

extension Animation {
    static var quickSpring: Animation {
        .smooth(duration: 0.2)
    }
    
    static var normalSpring: Animation {
        .smooth(duration: 0.3)
    }
    
    static var slowSpring: Animation {
        .smooth(duration: 0.7)
    }
    
    static var springy: Animation {
        .bouncy(duration: 0.25, extraBounce: 0.2)
    }
    
}
