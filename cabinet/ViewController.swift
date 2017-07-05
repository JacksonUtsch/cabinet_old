//
//  ViewController.swift
//  cabinet
//
//  Created by Jackson Utsch on 7/4/17.
//  Copyright © 2017 Jackson Utsch. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if dev == true{ print("Screen Size: \(screenSize)") }
        
        // get default directory (NSURL)
        // get list of files at this point
        // display based on viewing sys (organize by ..)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}
