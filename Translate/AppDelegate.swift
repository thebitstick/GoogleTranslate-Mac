//
//  AppDelegate.swift
//  Translate
//
//  Created by xaoxuu on 2019/4/5.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var statusMenu: NSMenu!
    
    let popover = NSPopover()
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var monitor: EventMonitor?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        let btn = statusItem.button
        btn?.image = NSImage.init(named: "logo_menu")
        
        popover.behavior = .transient
        popover.contentViewController = NSViewController.init(nibName: "WebVC", bundle: .main)
        btn?.action = #selector(toggleWebView(_:))
        monitor = EventMonitor.init(mask: .keyUp) { [weak self] (eve) in
            if self?.popover.isShown ?? false {
                self?.closePopover(sender: eve)
            }
        }
        
        let sound = NSSound.init(named: "Pop")
        sound?.play()
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func didTappedQuit(_ sender: NSButton) {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            NSApp.terminate(self)
        }
    }
    
    @objc func toggleWebView(_ sender: NSStatusBarButton) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }
    
    func showPopover(sender: Any){
        if let btn = statusItem.button {
            popover.show(relativeTo: btn.bounds, of: btn, preferredEdge: .minY)
        }
        monitor?.start()
    }
    
    func closePopover(sender: Any){
        popover.performClose(sender)
        monitor?.stop()
    }
    
    
}

