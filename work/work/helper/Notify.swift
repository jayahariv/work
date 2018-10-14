//
/*
Notify.swift
Created on: 10/7/18

Abstract:
 whenever any information needs to be notified to the user, this class will help in delivering those

*/

import Cocoa

final class Notify: NSObject {
    /// PUBLIC
    static var shared: Notify {
        return instance
    }
    /// PRIVATE
    private static let instance = Notify()
    func takeBreak() {
        let breakNotification = NSUserNotification()
        breakNotification.title = "Break"
        breakNotification.soundName = NSUserNotificationDefaultSoundName
        breakNotification.subtitle = "It's time to take a break."
        NSUserNotificationCenter.default.deliver(breakNotification)
    }
    
    func timeToWork() {
        let workNotification = NSUserNotification()
        workNotification.title = "Work"
        workNotification.soundName = NSUserNotificationDefaultSoundName
        workNotification.subtitle = "Be focused and time to work."
        NSUserNotificationCenter.default.deliver(workNotification)
    }
    
    func dailyTargetAchieved() {
        let targetNotification = NSUserNotification()
        targetNotification.title = "Daily target achieved"
        targetNotification.soundName = NSUserNotificationDefaultSoundName
        targetNotification.subtitle = "Congrats! You have achieved your daily target."
        NSUserNotificationCenter.default.deliver(targetNotification)
    }
}
