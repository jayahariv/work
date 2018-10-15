//
/*
UserPreference.swift
Created on: 10/9/18

Abstract:
 Wrapper for the preferences of user can be gathered from this class

*/

import Cocoa

final class UserPreference: NSObject {
    /// PUBLIC
    static var shared: UserPreference {
        return instance
    }
    /// PRIVATE
    private static let instance = UserPreference()
    private struct C {
        struct KEYS {
            static let DAILY_TARGET_KEY = "DAILY_TARGET_KEY"
            static let WORK_DURATION = "WORK_DURATION"
            static let SHORT_BREAK_DURATION = "SHORT_BREAK_DURATION"
            static let LONG_BREAK_DURATION = "LONG_BREAK_DURATION"
            static let LONG_BREAK_AFTER = "LONG_BREAK_AFTER"
        }
        struct DEFAULT {
            static let DAILY_TARGET = 8
            static let WORK_DURATION = 25
            static let SHORT_BREAK_DURATION = 5
            static let LONG_BREAK_DURATION = 15
            static let LONG_BREAK_AFTER = 4
        }
    }
    
    // MARK: DAILY TARGET
    
    var dailyWorkTarget: Int {
        let dailyTarget = UserDefaults.standard.integer(forKey: C.KEYS.DAILY_TARGET_KEY)
        return dailyTarget != 0 ? dailyTarget : C.DEFAULT.DAILY_TARGET
    }
    
    func saveDailyWorkTarget(_ target: Int) {
        UserDefaults.standard.set(target, forKey: C.KEYS.DAILY_TARGET_KEY)
    }
    
    // MARK: WORK DURATION
    var workDuration: Int {
        let workDuration = UserDefaults.standard.integer(forKey: C.KEYS.WORK_DURATION)
        return workDuration != 0 ? workDuration : C.DEFAULT.WORK_DURATION
    }
    
    func saveWorkDuration(_ duration: Int) {
        UserDefaults.standard.set(duration, forKey: C.KEYS.WORK_DURATION)
    }
    
    // MARK: Short Break Duration
    var shortBreakDuration: Int {
        let shortBreakDuration = UserDefaults.standard.integer(forKey: C.KEYS.SHORT_BREAK_DURATION)
        return shortBreakDuration != 0 ? shortBreakDuration : C.DEFAULT.SHORT_BREAK_DURATION
    }
    
    func saveShortBreakDuration(_ duration: Int) {
        UserDefaults.standard.set(duration, forKey: C.KEYS.SHORT_BREAK_DURATION)
    }
    
    // MARK: LONG BREAK DURATION
    var longBreakDuration: Int {
        let longBreakDuration = UserDefaults.standard.integer(forKey: C.KEYS.LONG_BREAK_DURATION)
        return longBreakDuration != 0 ? longBreakDuration : C.DEFAULT.LONG_BREAK_DURATION
    }
    
    func saveLongBreakDuration(_ duration: Int) {
        UserDefaults.standard.set(duration, forKey: C.KEYS.LONG_BREAK_DURATION)
    }
    
    // MARK: LONG BREAK AFTER
    var longBreakAfter: Int {
        let longBreakAfter = UserDefaults.standard.integer(forKey: C.KEYS.LONG_BREAK_AFTER)
        return longBreakAfter != 0 ? longBreakAfter : C.DEFAULT.LONG_BREAK_AFTER
    }
    
    func saveLongBreakAfter(_ duration: Int) {
        UserDefaults.standard.set(duration, forKey: C.KEYS.LONG_BREAK_AFTER)
    }
}
