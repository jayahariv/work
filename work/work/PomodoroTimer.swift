//
/*
PomodoroTimer.swift
Created on: 10/6/18

Abstract:
 This class will be the timer

*/

import Foundation
import Repeat

final class PomodoroTimer {
    /// PUBLIC
    static var shared: PomodoroTimer {
        return instance
    }
    var state: Repeater.State {
        return timer?.state ?? .finished
    }
    var time: String {
        return String(format: "%02d:%02d",
                      remainingSeconds / TimeConstants.MINUTE_IN_SECONDS,
                      remainingSeconds % TimeConstants.MINUTE_IN_SECONDS)
    }
    var minute: String {
        return String(format: "%02d", remainingSeconds / TimeConstants.MINUTE_IN_SECONDS)
    }
    
    struct Constants {
        struct NotificationName {
            static let TOGGLE = "NOTIFICATION_TOGGLE_NAME"
            static let FINISH = "NOTIFICATION_FINISH_NAME"
        }
        struct Interval {
            static let WORK = 25
            static let SHORT_BREAK = 1
            static let LONG_BREAK = 15
        }
    }
    /// PRIVATE
    private static let instance = PomodoroTimer()
    private var timer: Repeater?
    private var remainingSeconds: Int = 0
    private var isWorking: Bool = false
    
    /**
     Call this method once for setting up the timer from AppDelegate
     
     */
    func setupTimer() {
        guard timer == nil else {
            return
        }
        isWorking = true
        remainingSeconds = Constants.Interval.WORK * TimeConstants.MINUTE_IN_SECONDS
        timer = Repeater.every(.seconds(1)) { [weak self] (_) in
            guard let self = self else {
                return
            }
            
            guard self.remainingSeconds > 0 else {
                self.finishTimer()
                return
            }
            self.remainingSeconds -= 1
        }
        timer?.pause()
    }
    
    func toggle() {
        if timer == nil {
            setupTimer()
        }
        if timer?.state == .executing {
            timer?.pause()
        } else if timer?.state == .paused {
            timer?.start()
        }
        NotificationCenter.default.post(name: Notification.Name(PomodoroTimer.Constants.NotificationName.TOGGLE),
                                        object: nil)
    }
    
    func skip() {
        if let state = timer?.state, state == .executing {
            toggle()
        }
        
        if isWorking {
            remainingSeconds = Constants.Interval.SHORT_BREAK * TimeConstants.MINUTE_IN_SECONDS
        } else {
            remainingSeconds = Constants.Interval.WORK * TimeConstants.MINUTE_IN_SECONDS
        }
        isWorking.toggle()
    }
}

private extension PomodoroTimer {
    func finishTimer() {
        if isWorking {
            Notify.shared.takeBreak()
        } else {
            Notify.shared.timeToWork()
        }
        timer?.pause()
        skip()
    }
}
