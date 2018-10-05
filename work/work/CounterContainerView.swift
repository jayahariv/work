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
}

class CounterContainerView: NSView {
    var delegate:CounterContainerViewProtocol?
    
    override func mouseDown(with theEvent: NSEvent) {
        delegate?.onMouseDown()
    }
    
    override func rightMouseDown(with theEvent: NSEvent) {
        delegate?.onMouseRightClick?()
    }
}
