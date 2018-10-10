//
/*
PreferenceViewController.swift
Created on: 10/10/18

Abstract:
 Preference Page

*/

import Cocoa

final class PreferenceViewController: NSViewController {
    
    // MARK: Properties
    /// PRIVATE
    private struct C {
        static let TITLE = "Preferences"
    }

    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
    }
    
}

// MARK: Helper methods
private extension PreferenceViewController {
    func initializeUI() {
        title = C.TITLE
    }
}
