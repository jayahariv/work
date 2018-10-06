//
/*
CounterContainerView.swift
Created on: 10/5/18

Abstract:
 counter container, which will handle all the mouse actions and return the protocols to the caller.

*/

import Cocoa

@objc protocol CounterContainerViewProtocol {
    func onMouseDown()
    @objc optional func onMouseRightClick()
    func onCommandS()
}

class CounterContainerView: NSView {
    private let commandKey = NSEvent.ModifierFlags.command.rawValue

    var delegate:CounterContainerViewProtocol?
    
    override func mouseDown(with theEvent: NSEvent) {
        delegate?.onMouseDown()
    }
    
    override func rightMouseDown(with theEvent: NSEvent) {
        delegate?.onMouseRightClick?()
    }
    
    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        if event.type == .keyDown {
            if (event.modifierFlags.rawValue & NSEvent.ModifierFlags.deviceIndependentFlagsMask.rawValue) == commandKey {
                switch event.charactersIgnoringModifiers! {
                case "s":
                    if let delegate = delegate {
                        delegate.onCommandS()
                        return true
                    }
                default:
                    break
                }
            }
        }
        return super.performKeyEquivalent(with: event)
    }
}
