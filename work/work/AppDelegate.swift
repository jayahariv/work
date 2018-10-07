//
/*
AppDelegate.swift
Created on: 10/4/18

Abstract:
TODO: Purpose of file

*/

import Cocoa
import Repeat

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.variableLength)
    let popover = NSPopover()
    let counterViewController = CounterViewController.freshController()
    private let pomodoroTimer = PomodoroTimer.shared
    private var statusTitleUpdater: Repeater?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        initializeCounter()
    }
    
    // MARK: Button Actions
    
    @IBAction func togglePopover(_ sender: Any?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }
    
    @IBAction func toggleCounter(_ sender: Any) {
        pomodoroTimer.toggle()
    }
    
    // MARK: Helper methods
    
    func initializeCounter() {
        if let button = statusItem.button {
            button.title = "WoRk"
            button.action = #selector(togglePopover(_:))
        }
        popover.contentViewController = counterViewController
        pomodoroTimer.setupTimer()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateStatusTitle),
                                               name: NSNotification.Name(rawValue: PomodoroTimer.Constants.TOGGLE_NOTIFICATION_NAME),
                                               object: nil)
    }
    
    func showPopover(sender: Any?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }
    
    func closePopover(sender: Any?) {
        popover.performClose(sender)
    }
    
    @objc func updateStatusTitle() {
        print(pomodoroTimer.state)
        guard pomodoroTimer.state != .finished else {
            return
        }
        statusTitleUpdater = Repeater.every(.seconds(10)) { [weak self] (_) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                self.statusItem.button?.title = self.pomodoroTimer.displayTime()
            }
        }
        statusTitleUpdater?.start()
    }
}

