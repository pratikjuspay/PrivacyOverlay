import SwiftUI

struct OverlayView: View {
    @ObservedObject var manager: OverlayWindowManager
    @AppStorage("notes") private var notes: String = "Your private notes...\n\n```rust\nlet mut name = String::from(\"Hello\")\n```"
    @AppStorage("previewMarkdown") private var previewMarkdown: Bool = false
    
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
                Spacer()
                
                Button(action: { previewMarkdown.toggle() }) {
                    Image(systemName: previewMarkdown ? "pencil" : "doc.text.image")
                        .foregroundColor(.blue)
                        .help(previewMarkdown ? "Edit Notes" : "Preview Markdown")
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
            if previewMarkdown {
                ScrollView {
                    Text(SyntaxHighlighter.highlight(code: notes))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(10)
                }
                .background(Color(NSColor.windowBackgroundColor).opacity(0.8))
                .cornerRadius(8)
                .padding()
            } else {
                TextEditor(text: $notes)
                    .font(.body)
                    .scrollContentBackground(.hidden)
                    .padding(10)
                    .background(Color.black.opacity(0.15))
                    .cornerRadius(8)
                    .padding()
            }
            
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
