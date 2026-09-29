import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var globalEventMonitor: Any?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Setup floating window and menu bar item
        OverlayWindowManager.shared.setupPanel()
        StatusItemManager.shared.setup()
        
        // Register global keyboard shortcut (Cmd+Shift+O)
        // NOTE: This requires Accessibility permissions in System Settings -> Privacy & Security
        globalEventMonitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { event in
            // cmdKey = command, shiftKey = shift
            if event.modifierFlags.contains([.command, .shift]) && event.keyCode == 31 { // 31 is 'O' key
                OverlayWindowManager.shared.toggleVisibility()
            }
        }
        
        // Also add local monitor so shortcut works when app is active (e.g. Settings open)
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            if event.modifierFlags.contains([.command, .shift]) && event.keyCode == 31 {
                OverlayWindowManager.shared.toggleVisibility()
                return nil
            }
            return event
        }
    }
}
