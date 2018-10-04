//
/*
CounterViewController.swift
Created on: 10/4/18

Abstract:
TODO: Purpose of file

*/

import Cocoa

class CounterViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

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


