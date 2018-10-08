//
/*
Notify.swift
Created on: 10/7/18

Abstract:
 whenever any information needs to be notified to the user, this class will help in delivering those

*/

import Foundation

final class Notify: NSObject {
    /// PUBLIC
    static var shared: Notify {
        return instance
    }
    /// PRIVATE
    private static let instance = Notify()
    private let breakNotification = NSUserNotification()
    private let workNotification = NSUserNotification()
    func initialize() {
        initializeBreakNotification()
        initializeWorkNotification()
    }
    
    func takeBreak() {
        NSUserNotificationCenter.default.deliver(breakNotification)
    }
    
    func timeToWork() {
        NSUserNotificationCenter.default.deliver(workNotification)
    }
}

private extension Notify {
    func initializeBreakNotification() {
        breakNotification.title = "Break"
        breakNotification.soundName = NSUserNotificationDefaultSoundName
        breakNotification.subtitle = "It's time to take a break."
    }
    
    func initializeWorkNotification() {
        workNotification.title = "Work"
        workNotification.soundName = NSUserNotificationDefaultSoundName
        workNotification.subtitle = "Be focused and time to work."
    }
}
