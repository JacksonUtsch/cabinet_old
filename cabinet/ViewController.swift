//
//  ViewController.swift
//  cabinet
//
//  Created by Jackson Utsch on 7/4/17.
//  Copyright © 2017 Jackson Utsch. All rights reserved.
//

import Cocoa
import PureLayout

let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]

/// Creates access to the root of application, many elements will rely of this.
var VCRef:ViewController!
var appLayout = layout()

class ViewController: NSViewController {
    
    var viewer:CViewer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if dev == true{ print("Screen Size: \(screenSize)") }

        VCRef = self
        
        viewer = CViewer(frame: self.view.frame, path: URL(fileURLWithPath: documentsPath))
        self.view.addSubview(viewer)
        
        /* AUTO LAYOUT */
        viewer.autoMatch(.width, to: .width, of: view)
        viewer.autoMatch(.height, to: .height, of: view)
        viewer.autoPinEdgesToSuperviewEdges(with: .init(top: 0, left: 0, bottom: 0, right: 0), excludingEdge: .bottom)
    }
}

extension Bool {
    
    mutating func toggle() {
        if self == true  {
            self = false
        } else {
            self = true
        }
    }
    
    func toggled() -> Bool {
        if self == true  {
            return false
        } else {
            return true
        }
    }
}

extension NSTextField {
    func makeNormal() {
        self.isBezeled = false
        self.isEditable = false
        self.isSelectable = false
        self.isEditable = false
        self.alignment = .center
        self.font = NSFont(name: "Avenir Next", size: self.frame.height/2)
    }
}
