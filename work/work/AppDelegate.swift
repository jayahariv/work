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
    private var eventMonitor: EventMonitor?
    private var notesWindowController: NSWindowController!

    
    // MARK: Application Lifecycle

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        initializeEventMonitor()
        initializeCounter()
        initializePreferenceWindow()
        initializeNotesWindow()
    }
    
    // MARK: Button Actions
    
    @IBAction func togglePopover(_ sender: Any?) {
        if popover.isShown {
            closePopover(sender)
        } else {
            showPopover(sender)
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
    
    @IBAction func onNotes(_ sender: Any) {
        toggleNotesViewController()
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
    
    func initializeEventMonitor() {
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            if let self = self, self.popover.isShown {
                self.closePopover(event)
            }
        }
    }
    
    func showPopover(_ sender: Any?) {
        if let button = statusItem.button {
            eventMonitor?.start()
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }
    
    func closePopover(_ sender: Any?) {
        popover.performClose(sender)
        eventMonitor?.stop()
    }
    
    @objc func updateStatusTitle() {
        if statusTitleUpdater == nil {
            statusItem.button?.title = "~"
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
        guard
            let vc =
                storyboard
                    .instantiateController(withIdentifier: "PreferenceViewController")
                        as? PreferenceViewController
        else {
            fatalError("Preferences window is not in the storyboard")
        }
        let myWindow = NSWindow(contentViewController: vc)
        myWindow.styleMask = [.titled, .closable ]
        preferenceWindowController = NSWindowController(window: myWindow)
    }
    func openPreferenceViewController() {
        preferenceWindowController.showWindow(self)
    }
}

private extension AppDelegate {
    func initializeNotesWindow() {
        let storyboard = NSStoryboard(name: "Notes",bundle: nil)
        guard
            let vc =
                storyboard
                    .instantiateController(withIdentifier: "NotesHomeViewController")
                        as? NotesHomeViewController
            else {
            fatalError("NotesHomeViewController is not in the storyboard")
        }
        let myWindow = NSWindow(contentViewController: vc)
        notesWindowController = NSWindowController(window: myWindow)
    }
    func toggleNotesViewController() {
        if notesWindowController.window?.isVisible ?? false {
            notesWindowController.window?.close()
        } else {
            notesWindowController.showWindow(self)
        }
    }
}


