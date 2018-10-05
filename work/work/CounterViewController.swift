//
/*
CounterViewController.swift
Created on: 10/4/18

Abstract:
 This will be the popover view controller

*/

import Cocoa

final class CounterViewController: NSViewController {
    @IBOutlet weak var quitButton: NSButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
    }
    
    @IBAction func onQuit(_ sender: Any) {
        NSApplication.shared.terminate(sender)
    }
}

extension CounterViewController {
    static func freshController() -> CounterViewController {
        guard let viewcontroller =
            NSStoryboard(name: "Main", bundle: nil)
                .instantiateController(withIdentifier: "CounterViewController")
                    as? CounterViewController
        else {
            fatalError("Why cant i find CounterViewController? - Check Main.storyboard")
        }
        return viewcontroller
    }
}

private extension CounterViewController {
    func initializeView() {
        quitButton.keyEquivalent = "q"
    }
}


