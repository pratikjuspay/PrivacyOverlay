import Cocoa
import SwiftUI

class OverlayWindowManager: NSObject, ObservableObject {
    static let shared = OverlayWindowManager()
    
    var panel: NSPanel?
    
    @Published var isVisible = true
    @Published var isAlwaysOnTop = true {
        didSet {
            UserDefaults.standard.set(isAlwaysOnTop, forKey: "isAlwaysOnTop")
            updateWindowLevel()
        }
    }
    @Published var isClickThrough = false {
        didSet {
            updateClickThrough()
        }
    }
    @Published var opacity: Double = 0.8 {
        didSet {
            UserDefaults.standard.set(opacity, forKey: "opacity")
            panel?.alphaValue = CGFloat(opacity)
        }
    }
    
    override init() {
        super.init()
        // Load saved preferences
        if UserDefaults.standard.object(forKey: "isAlwaysOnTop") != nil {
            isAlwaysOnTop = UserDefaults.standard.bool(forKey: "isAlwaysOnTop")
        }
        // Deliberately NOT loading isClickThrough so it always defaults to false (interactive) on launch.
        if UserDefaults.standard.object(forKey: "opacity") != nil {
            opacity = UserDefaults.standard.double(forKey: "opacity")
        }
    }
    
    func setupPanel() {
        // Create the floating panel
        let panel = NSPanel(
            contentRect: NSRect(x: 100, y: 100, width: 350, height: 400),
            styleMask: [.titled, .resizable, .closable, .utilityWindow, .nonactivatingPanel, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        
        // -------------------------------------------------------------
        // MAC OS PRIVACY API - CRITICAL FOR SCREEN EXCLUSION
        // -------------------------------------------------------------
        // .none: Excludes the window from capture by standard macOS Screen Recording, 
        // ScreenCaptureKit, and standard screenshots. This is the documented way 
        // to implement privacy screens.
        panel.sharingType = .none 
        
        panel.titlebarAppearsTransparent = true
        panel.titleVisibility = .hidden
        panel.isFloatingPanel = true
        // Allow joining all spaces so it doesn't disappear when switching desktops
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        panel.isOpaque = false
        panel.backgroundColor = .clear
        
        // ALLOW DRAGGING BY WINDOW BACKGROUND
        panel.isMovableByWindowBackground = true
        
        self.panel = panel
        
        // Host the SwiftUI view
        let contentView = OverlayView(manager: self)
        panel.contentView = NSHostingView(rootView: contentView)
        
        updateWindowLevel()
        updateClickThrough()
        panel.alphaValue = CGFloat(opacity)
        
        // Restore previous frame if available
        panel.setFrameUsingName("PrivacyOverlayFrame")
        panel.setFrameAutosaveName("PrivacyOverlayFrame")
        
        if isVisible {
            panel.makeKeyAndOrderFront(nil)
        }
    }
    
    func toggleVisibility() {
        isVisible.toggle()
        if isVisible {
            panel?.makeKeyAndOrderFront(nil)
        } else {
            panel?.orderOut(nil)
        }
    }
    
    private func updateWindowLevel() {
        panel?.level = isAlwaysOnTop ? .floating : .normal
    }
    
    private func updateClickThrough() {
        panel?.ignoresMouseEvents = isClickThrough
    }
}
