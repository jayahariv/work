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
    @IBOutlet private weak var counterTextfield: NSTextField?
    @IBOutlet private weak var countersubheading: NSTextField?
    @IBOutlet private weak var quitButton: NSButton!
    @IBOutlet private weak var counterContainer: CounterContainerView!
    private let pomodoroTimer = PomodoroTimer.shared
    private var uiUpdater: Repeater?
    private struct C {
        static let COUNTER_START_LABEL = "Start (⌘R)"
        static let COUNTER_PAUSE_LABEL = "Pause (⌘R)"
    }

    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
        updateCounter()
        
    }
    
    // MARK: Button Actions
    @IBAction func onQuit(_ sender: Any) {
        NSApplication.shared.terminate(sender)
    }
    
    @objc func updateSubHeading() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            if self.pomodoroTimer.state == .executing {
                self.countersubheading?.stringValue = C.COUNTER_PAUSE_LABEL
            } else if self.pomodoroTimer.state == .paused {
                self.countersubheading?.stringValue = C.COUNTER_START_LABEL
            }
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
        countersubheading?.stringValue = C.COUNTER_START_LABEL
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateSubHeading),
                                               name: NSNotification.Name(rawValue: PomodoroTimer.Constants.TOGGLE_NOTIFICATION),
                                               object: nil)
    }
    
    func updateCounter() {
        uiUpdater = Repeater.every(.seconds(1)) { [weak self] (_) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                self.counterTextfield?.stringValue = self.pomodoroTimer.getTime()
            }
        }
        uiUpdater?.start()
        updateSubHeading()
    }
}


extension CounterViewController: CounterContainerViewProtocol {
    func onMouseDown() {
        pomodoroTimer.toggle()
    }
}

