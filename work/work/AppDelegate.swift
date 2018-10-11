//
/*
AppDelegate.swift
Created on: 10/4/18

Abstract:
AppDelegate

*/

import Cocoa
import Repeat

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSUserNotificationCenterDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.variableLength)
    let popover = NSPopover()
    let counterViewController = CounterViewController.freshController()
    private let pomodoroTimer = PomodoroTimer.shared
    private var statusTitleUpdater: Repeater?
    private var preferenceWindowController: NSWindowController!    
    
    // MARK: Application Lifecycle

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        initializeCounter()
        initializePreferenceWindow()
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
    
    @IBAction func onSkipInterval(_ sender: Any){
        pomodoroTimer.skip()
        statusItem.button?.title = "~\(pomodoroTimer.minute)"
    }
    
    @IBAction func onPreference(_ sender: Any) {
        openPreferenceViewController()
    }
}

// MARK: Pomodoro related

private extension AppDelegate {
    func initializeCounter() {
        if let button = statusItem.button {
            let icon = NSImage(named: NSImage.Name("StatusIcon"))
            icon?.isTemplate = true
            button.image = icon
            button.imagePosition = .imageRight
            button.title = ""
            button.action = #selector(togglePopover(_:))
        }
        popover.contentViewController = counterViewController
        pomodoroTimer.setupTimer()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateStatusTitle),
                                               name: NSNotification.Name(rawValue: PomodoroTimer.Constants.NotificationName.TOGGLE),
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
        if statusTitleUpdater == nil {
            statusItem.button?.title = "~25"
            setupStatusTitle()
        }
        
        switch pomodoroTimer.state {
        case .paused:
            statusTitleUpdater?.pause()
        case .executing:
            statusTitleUpdater?.start()
        default:
            break
        }
    }
    
    func setupStatusTitle() {
        statusTitleUpdater = Repeater.every(.seconds(1)) { [weak self] (_) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                self.statusItem.button?.title = "~\(self.pomodoroTimer.time)"
            }
        }
        statusTitleUpdater?.start()
    }
}

// MARK: Preference related helper methods
private extension AppDelegate {
    func initializePreferenceWindow() {
        let storyboard = NSStoryboard(name: "Main",bundle: nil)
        guard let vc = storyboard.instantiateController(withIdentifier: "PreferenceViewController") as? PreferenceViewController else {
            fatalError("Preferences window is not in the storyboard")
        }
        let myWindow = NSWindow(contentViewController: vc)
        preferenceWindowController = NSWindowController(window: myWindow)
    }
    func openPreferenceViewController() {
        preferenceWindowController.showWindow(self)
    }
}


