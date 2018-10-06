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
    @IBOutlet private weak var counterTextfield: NSTextField!
    @IBOutlet private weak var countersubheading: NSTextField!
    @IBOutlet private weak var quitButton: NSButton!
    @IBOutlet private weak var counterContainer: CounterContainerView!
    private var timer: Repeater?
    private var remainingSeconds: Int = 0
    private struct C {
        static let LONG_INTERVAL_SEC = 1500
        static let SHORT_BREAK_SEC = 300
        static let LONG_BREAK_SEC = 900
        static let COUNTER_START_LABEL = "Start"
        static let COUNTER_PAUSE_LABEL = "Pause"
    }

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
            countersubheading.stringValue = C.COUNTER_START_LABEL
        } else if timer?.state == .paused {
            timer?.start()
            countersubheading.stringValue = C.COUNTER_PAUSE_LABEL
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
        remainingSeconds = C.LONG_INTERVAL_SEC
        countersubheading.stringValue = C.COUNTER_START_LABEL
    }
    
    func configureTimer() {
        timer = Repeater.every(.seconds(1)) { [weak self] (_) in
            guard let self = self else {
                return
            }
            
            guard self.remainingSeconds > 0 else {
                self.resetTimer()
                return
            }
            self.remainingSeconds -= 1
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                let minutesPart = self.remainingSeconds/TimeConstants.MINUTE_IN_SECONDS
                let secondsPart = self.remainingSeconds%TimeConstants.MINUTE_IN_SECONDS
                self.counterTextfield.stringValue = String(format: "%02d:%02d", minutesPart, secondsPart)
            }
            print(self.remainingSeconds)
        }
        timer?.pause()
    }
    
    func resetTimer() {
        timer = nil
    }
}


extension CounterViewController: CounterContainerViewProtocol {
    func onMouseDown() {
        onToggleTimer()
    }
}

