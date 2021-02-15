//
//  NoteDetailViewController.swift
//  CloudNotes
//
//  Created by 김지혜 on 2021/02/15.
//

import UIKit

class NoteDetailViewController: UIViewController {
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet private weak var noteTextView: UITextView!
    var model: Note?
    
    @IBAction func textViewDidTapped(_ tapRecognizer: UITapGestureRecognizer) {
        guard let textView = tapRecognizer.view as? UITextView else { return }
        let layoutManager = textView.layoutManager
        let attributeName = NSAttributedString.Key.link
        
        var tappedLocation = tapRecognizer.location(in: textView)
        tappedLocation.x -= textView.textContainerInset.left
        tappedLocation.y -= textView.textContainerInset.top
        // 이렇게나 복잡할일인가..?
        let glyphIndex: Int = textView.layoutManager.glyphIndex(for: tappedLocation, in: textView.textContainer, fractionOfDistanceThroughGlyph: nil)
        let characterIndex: Int = layoutManager.characterIndexForGlyph(at: glyphIndex)
        
        let attributeValue = textView.textStorage.attribute(attributeName, at: characterIndex, effectiveRange: nil)
        
        if let url = attributeValue as? URL {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("There is a problem in your link.")
            }
        } else {
            placeCursor(textView, tappedLocation)
            setupToEditMode()
        }
    }
    
    func setModel(_ model: Note) {
        self.model = model
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupToViewMode()
        guard let note = model else { return }
        noteTextView.text = note.body
    }
    
    private func setupToViewMode() {
        noteTextView.dataDetectorTypes = [.link, .phoneNumber, .calendarEvent]
        noteTextView.isEditable = false
    }
    
    private func setupToEditMode() {
        noteTextView.dataDetectorTypes = []
        noteTextView.isEditable = true
        noteTextView.becomeFirstResponder()
    }
    
    private func placeCursor(_ textView: UITextView, _ tappedLocation: CGPoint) {
        if let position = textView.closestPosition(to: tappedLocation) {
            let uiTextRange = textView.textRange(from: position, to: position)
            
            if let start = uiTextRange?.start, let end = uiTextRange?.end {
                let loc = textView.offset(from: textView.beginningOfDocument, to: position)
                let length = textView.offset(from: start, to: end)
                textView.selectedRange = NSMakeRange(loc, length)
            }
        }
    }
}

extension NoteDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        // 수정과 동시에 저장
        //setupTextView()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        setupToViewMode()
    }
}
