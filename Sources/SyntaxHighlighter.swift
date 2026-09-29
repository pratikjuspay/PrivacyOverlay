import Cocoa
import Foundation

struct SyntaxHighlighter {
    static func highlight(code: String) -> NSAttributedString {
        let attrStr = NSMutableAttributedString(string: code)
        let fullRange = NSRange(location: 0, length: code.utf16.count)
        
        // Base Attributes (White text, 15pt monospaced font)
        let baseFont = NSFont.monospacedSystemFont(ofSize: 15, weight: .regular)
        attrStr.addAttribute(.font, value: baseFont, range: fullRange)
        attrStr.addAttribute(.foregroundColor, value: NSColor.white, range: fullRange)
        
        // Helper to apply color
        func applyColor(_ color: NSColor, pattern: String) {
            if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
                let matches = regex.matches(in: code, range: fullRange)
                for match in matches {
                    attrStr.addAttribute(.foregroundColor, value: color, range: match.range)
                }
            }
        }
        
        // 1. Match Keywords (Pink)
        let keywords = ["let", "mut", "fn", "enum", "struct", "class", "var", "func", "if", "else", "return", "true", "false", "import", "public", "private", "match", "for", "while"]
        let keywordPattern = "\\b(" + keywords.joined(separator: "|") + ")\\b"
        applyColor(NSColor.systemPink, pattern: keywordPattern)
        
        // 2. Match Types/Structs (Cyan)
        let types = ["String", "Option", "Result", "Some", "None", "Ok", "Err", "str", "Int", "Bool", "Float", "Double"]
        let typePattern = "\\b(" + types.joined(separator: "|") + ")\\b"
        applyColor(NSColor.systemCyan, pattern: typePattern)
        
        // 3. Match Strings (Orange/Yellow)
        applyColor(NSColor.systemYellow, pattern: "\".*?\"")
        
        // 4. Match Comments (Gray)
        applyColor(NSColor.systemGray, pattern: "//.*")
        
        return attrStr
    }
}
