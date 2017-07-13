//
//  Design.swift
//  cabinet
//
//  Created by Jackson Utsch on 7/4/17.
//  Copyright © 2017 Jackson Utsch. All rights reserved.
//

import DynamicColor

struct Design {
    
    struct window {
        static let color = colors.blue.darkened()
    }
    
    struct fileViewer {
        static let color = colors.gray
        
        struct folder {
            static let selectAlpha:CGFloat = 0.4
            static let selectCornerRadius:CGFloat = 4
        }
    }
}

//preset themes
//sizing options
