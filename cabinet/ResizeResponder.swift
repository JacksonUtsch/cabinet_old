//
//  ResizeResponder.swift
//  cabinet
//
//  Created by Jackson Utsch on 7/6/17.
//  Copyright © 2017 Jackson Utsch. All rights reserved.
//

import Cocoa

// does not work

class ResizeResponder:NSWindowController, NSWindowDelegate {
    
    func windowDidResize(_ notification: Notification) {
        Swift.print("didResize")
    }
}
