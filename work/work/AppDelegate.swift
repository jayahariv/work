//
/*
AppDelegate.swift
Created on: 10/4/18

Abstract:
TODO: Purpose of file

*/

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    let popover = NSPopover()
    let counterViewController = CounterViewController.freshController()
    private let pomodoroTimer = PomodoroTimer.shared

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
            let image = NSImage(named:NSImage.Name("statusIcon"))
            image?.isTemplate = true
            button.image = image
            button.action = #selector(togglePopover(_:))
        }
        popover.contentViewController = counterViewController
        pomodoroTimer.setupTimer()
    }
    
    func showPopover(sender: Any?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }
    
    func closePopover(sender: Any?) {
        popover.performClose(sender)
    }
}

