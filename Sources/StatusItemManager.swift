import Cocoa
import SwiftUI

class StatusItemManager: NSObject {
    static let shared = StatusItemManager()
    var statusItem: NSStatusItem?
    
    func setup() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "eye.slash.fill", accessibilityDescription: "Privacy Overlay")
        }
        
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Toggle Overlay", action: #selector(toggleOverlay), keyEquivalent: "o"))
        menu.addItem(NSMenuItem(title: "Toggle Click-Through", action: #selector(toggleClickThrough), keyEquivalent: "c"))
        menu.addItem(NSMenuItem(title: "Settings...", action: #selector(openSettings), keyEquivalent: ","))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit Privacy Overlay", action: #selector(quitApp), keyEquivalent: "q"))
        
        for item in menu.items {
            item.target = self
        }
        
        statusItem?.menu = menu
    }
    
    @objc func toggleOverlay() {
        OverlayWindowManager.shared.toggleVisibility()
    }
    
    @objc func toggleClickThrough() {
        OverlayWindowManager.shared.isClickThrough.toggle()
    }
    
    @objc func openSettings() {
        // Send action to open the standard SwiftUI Settings window
        NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @objc func quitApp() {
        NSApplication.shared.terminate(self)
    }
}
