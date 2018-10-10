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
    /// PRIVATE
    @IBOutlet private weak var counterTextfield: NSTextField?
    @IBOutlet private weak var countersubheading: NSTextField?
    @IBOutlet private weak var counterContainer: CounterContainerView!
    private let pomodoroTimer = PomodoroTimer.shared
    private var uiUpdater: Repeater?

    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
        updateCounter()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        countersubheading?.stringValue =
            "\(pomodoroTimer.todaysFinishedTaskCount)/\(UserPreference.shared.targetTaskCount)"
    }
    
    // MARK: Button Actions
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
        counterContainer.delegate = self
    }
    
    func updateCounter() {
        uiUpdater = Repeater.every(.seconds(1)) { [weak self] (_) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                self.counterTextfield?.stringValue = self.pomodoroTimer.time
            }
        }
        uiUpdater?.start()
    }
}

extension CounterViewController: CounterContainerViewProtocol {
    func onMouseDown() {
        pomodoroTimer.toggle()
    }
}
