import SwiftUI
import AppKit

struct SyntaxTextView: NSViewRepresentable {
    @Binding var text: String

    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSTextView.scrollableTextView()
        scrollView.drawsBackground = false
        
        guard let textView = scrollView.documentView as? NSTextView else { return scrollView }
        
        textView.delegate = context.coordinator
        textView.backgroundColor = .clear
        textView.isRichText = false
        textView.allowsUndo = true
        textView.font = .monospacedSystemFont(ofSize: 15, weight: .regular)
        textView.textColor = NSColor.white
        textView.insertionPointColor = NSColor.white
        
        // Initial setup
        let attrStr = SyntaxHighlighter.highlight(code: text)
        textView.textStorage?.setAttributedString(attrStr)
        
        return scrollView
    }

    func updateNSView(_ nsView: NSScrollView, context: Context) {
        guard let textView = nsView.documentView as? NSTextView else { return }
        
        if textView.string != text {
            let attrStr = SyntaxHighlighter.highlight(code: text)
            let selectedRange = textView.selectedRange()
            
            textView.textStorage?.beginEditing()
            textView.textStorage?.setAttributedString(attrStr)
            textView.textStorage?.endEditing()
            
            // Restore cursor position if possible
            if selectedRange.location <= textView.string.count {
                textView.setSelectedRange(selectedRange)
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: SyntaxTextView
        var isUpdating = false

        init(_ parent: SyntaxTextView) {
            self.parent = parent
        }

        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView, !isUpdating else { return }
            
            isUpdating = true
            let newText = textView.string
            
            // Update SwiftUI binding
            DispatchQueue.main.async {
                self.parent.text = newText
            }
            
            // Re-apply syntax highlighting dynamically
            let attrStr = SyntaxHighlighter.highlight(code: newText)
            let selectedRange = textView.selectedRange()
            
            textView.textStorage?.beginEditing()
            textView.textStorage?.setAttributedString(attrStr)
            textView.textStorage?.endEditing()
            
            textView.setSelectedRange(selectedRange)
            isUpdating = false
        }
    }
}
