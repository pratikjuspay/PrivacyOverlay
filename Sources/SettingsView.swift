import SwiftUI

struct SettingsView: View {
    @ObservedObject var manager = OverlayWindowManager.shared
    
    var body: some View {
        Form {
            Section(header: Text("Overlay Configuration")) {
                Toggle("Always on Top", isOn: $manager.isAlwaysOnTop)
                Toggle("Click-Through Mode", isOn: $manager.isClickThrough)
                    .help("When enabled, the overlay ignores mouse clicks. Disable this via the menu bar icon to interact with the notes again.")
                
                HStack {
                    Text("Opacity")
                    Slider(value: $manager.opacity, in: 0.1...1.0)
                }
                
                Text("Global Shortcut: Cmd + Shift + O (Requires Accessibility permissions)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.bottom)
            
            Section(header: Text("Privacy Information & Testing")) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("This application uses **`NSWindow.sharingType = .none`** to prevent the overlay from being captured.")
                    
                    Text("⚠️ **Important Constraints:**")
                        .foregroundColor(.orange)
                        .bold()
                    
                    Text("Capture exclusion is generally respected by:")
                    Text("• macOS Screenshots (Cmd+Shift+3 or 4)")
                    Text("• Screen Recording via QuickTime")
                    Text("• ScreenCaptureKit (in standard app configurations)")
                    
                    Text("However, it **cannot be guaranteed** against every screen-sharing tool. Third-party applications (like older versions of Zoom, Teams, or tools using Accessibility capture mechanisms) might bypass these protections.")
                    
                    Text("Test this by starting a screen share in your desired meeting app and using another device to see if the overlay is visible before relying on it for sensitive information.")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .frame(width: 450, height: 450)
    }
}
