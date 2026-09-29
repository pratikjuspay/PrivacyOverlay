import SwiftUI

struct OverlayView: View {
    @ObservedObject var manager: OverlayWindowManager
    @ObservedObject var sync = SyncManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header / Title Bar
            HStack {
                Image(systemName: "line.3.horizontal")
                    .foregroundColor(.secondary)
                    .help("Drag anywhere in the background to move")
                Text("Privacy Overlay")
                    .font(.headline)
                    .foregroundColor(.primary)
                if sync.isSyncing {
                    Text("Room: \(sync.roomCode)")
                        .font(.caption)
                        .bold()
                        .foregroundColor(.green)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(4)
                }
                
                Button(action: { sync.toggleSync() }) {
                    Image(systemName: sync.isSyncing ? "person.2.fill" : "person.2")
                        .foregroundColor(sync.isSyncing ? .green : .secondary)
                        .help(sync.isSyncing ? "Stop Syncing" : "Share via Web")
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.trailing, 8)
                
                Button(action: { manager.toggleVisibility() }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding()
            .background(Color.black.opacity(0.1))
            
            // Notes Area
            SyntaxTextView(text: $sync.notes)
                .padding(10)
                .background(Color.black.opacity(0.15))
                .cornerRadius(8)
                .padding()
            
            Divider()
            
            // Controls Area
            VStack(spacing: 12) {
                HStack {
                    Toggle("Always on Top", isOn: $manager.isAlwaysOnTop)
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                    Spacer()
                }
                
                HStack {
                    Text("Opacity")
                    Slider(value: $manager.opacity, in: 0.1...1.0)
                        .accentColor(.blue)
                }
                
                HStack {
                    Image(systemName: "lock.shield.fill")
                        .foregroundColor(.green)
                    Text("Capture Protection Active")
                        .font(.caption)
                        .bold()
                        .foregroundColor(.green)
                    Spacer()
                }
            }
            .padding()
            .background(Color.black.opacity(0.1))
        }
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }
}
