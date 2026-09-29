import SwiftUI
import Foundation

struct SyntaxHighlighter {
    static func highlight(code: String) -> AttributedString {
        var attrStr = AttributedString(code)
        
        // Default text style (Base color for code)
        attrStr.font = .system(size: 15, weight: .regular, design: .monospaced)
        attrStr.foregroundColor = Color.white
        
        let stringNs = code as NSString
        let fullRange = NSRange(location: 0, length: stringNs.length)
        
        // Helper to apply color
        func applyColor(_ color: Color, pattern: String) {
            if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
                for match in regex.matches(in: code, range: fullRange) {
                    if let stringRange = Range(match.range, in: code),
                       let attrRange = Range<AttributedString.Index>(stringRange, in: attrStr) {
                        attrStr[attrRange].foregroundColor = color
                    }
                }
            }
        }
        
        // 1. Match Keywords (Pink)
        let keywords = ["let", "mut", "fn", "enum", "struct", "class", "var", "func", "if", "else", "return", "true", "false", "import", "public", "private", "match", "for", "while"]
        let keywordPattern = "\\b(" + keywords.joined(separator: "|") + ")\\b"
        applyColor(.pink, pattern: keywordPattern)
        
        // 2. Match Types/Structs (Cyan)
        let types = ["String", "Option", "Result", "Some", "None", "Ok", "Err", "str", "Int", "Bool", "Float", "Double"]
        let typePattern = "\\b(" + types.joined(separator: "|") + ")\\b"
        applyColor(.cyan, pattern: typePattern)
        
        // 3. Match Strings (Orange/Yellow)
        applyColor(.yellow, pattern: "\".*?\"")
        
        // 4. Match Comments (Gray)
        applyColor(.gray, pattern: "//.*")
        
        return attrStr
    }
}
