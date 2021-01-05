//
//  AttributedText.swift
//  iOSTest
//
//  Created by Luisa Cruz Molina on 03.01.21.
//

import Foundation
import UIKit

private func findWordsBetweenBrackets(text: String) -> [String] {
    let regex = try! NSRegularExpression(pattern: "\\[(.*?)\\]", options: [])
    let matches = regex.matches(in: text, options: [], range: NSRange(text.startIndex..., in: text))
    var words: [String] = []
    
    matches.compactMap { Range($0.range(at: 1), in: text) }
        .forEach {
            let w = String(text[$0])
            words.append(w)
        }
    
    return words
}

func applyItalicAttribute(text: String) -> NSMutableAttributedString {
    let cleanText = text.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")
    
    let font = UIFont.preferredFont(forTextStyle: .caption2)
    let attributedString = NSMutableAttributedString(string: cleanText, attributes: [.font: font])
    let italicFont = font.italicFont!
    let italicAttributes: [NSAttributedString.Key: Any] = [.font: italicFont]
    
    let words = findWordsBetweenBrackets(text: text)
    words.map { (cleanText as NSString).range(of: $0) }.forEach {
            attributedString.addAttributes(italicAttributes, range: $0)
        }
    return attributedString
}
