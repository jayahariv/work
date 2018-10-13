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
    static let instance = UserPreference()
    
    var targetTaskCount: Int {
        return 8
    }
}
