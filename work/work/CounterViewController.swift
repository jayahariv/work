//
/*
CounterViewController.swift
Created on: 10/4/18

Abstract:
 This will be the popover view controller

*/

import Cocoa
import Repeat

final class CounterViewController: NSViewController {
    // MARK: Properties
    @IBOutlet private weak var quitButton: NSButton!
    @IBOutlet private weak var counterContainer: CounterContainerView!
    private var timer: Repeater?
    private var remainingSeconds: Int = 0

    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
        configureTimer()
    }
    
    // MARK: Button Actions
    @IBAction func onQuit(_ sender: Any) {
        NSApplication.shared.terminate(sender)
    }
    
    @objc func onToggleTimer() {
        if timer?.state == .executing {
            timer?.pause()
        } else if timer?.state == .paused {
            timer?.start()
        }
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
        counterContainer.delegate = self
        remainingSeconds = 1500
    }
    
    func configureTimer() {
        timer = Repeater.every(.seconds(1)) { [weak self] (_) in
            guard let self = self else {
                return
            }
            self.remainingSeconds -= 1
            DispatchQueue.main.async {
                // update UI
            }
            print(self.remainingSeconds)
        }
    }
}


extension CounterViewController: CounterContainerViewProtocol {
    func onMouseDown() {
        onToggleTimer()
    }
}

