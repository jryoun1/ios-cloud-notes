//
//  MemoTextView.swift
//  CloudNotes
//
//  Created by 김지혜 on 2021/02/21.
//

import UIKit

final class MemoTextView: UITextView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let glyphIndex = self.layoutManager.glyphIndex(for: point, in: self.textContainer)
        let glyphRect = self.layoutManager.boundingRect(forGlyphRange: NSRange(location: glyphIndex, length: 1), in: self.textContainer)
        
        if glyphIndex < self.textStorage.length,
           glyphRect.contains(point),
           self.textStorage.attribute(NSAttributedString.Key.link, at: glyphIndex, effectiveRange: nil) == nil {
            setUpEditMode()
        }
        
        return self
    }
    
    private func setUpEditMode() {
        self.isEditable = true
        self.dataDetectorTypes = []
    }
}
