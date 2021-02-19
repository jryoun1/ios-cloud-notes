//
//  DetailViewController.swift
//  CloudNotes
//
//  Created by Yeon on 2021/02/16.
//

import UIKit

final class DetailViewController: UIViewController {
    private var memo: Memo? {
        didSet {
            refreshUI()
        }
    }
    
    private var memoBodyTextView: UITextView = {
        let textView = UITextView()
//        let contentHeight = textView.contentSize.height
//        let offSet = textView.contentOffset.x
//        let contentOffSet = contentHeight - offSet
//        textView.contentOffset = CGPoint(x: 0, y: -contentOffSet)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.dataDetectorTypes = [.link, .phoneNumber, .calendarEvent]
        textView.isSelectable = true
        textView.isEditable = false
        textView.isUserInteractionEnabled = true
        textView.font = .preferredFont(forTextStyle: .body)
        textView.textColor = .black
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextView()
        setupNavigationBar()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        if traitCollection.horizontalSizeClass == .regular &&
            UIDevice.current.orientation.isLandscape {
            navigationController?.navigationBar.isHidden = true
        }
        else {
            navigationController?.navigationBar.isHidden = false
        }
    }
    
    private func setupTextView() {
        setTapGesture()
        self.view.backgroundColor = .white
        view.addSubview(memoBodyTextView)
        NSLayoutConstraint.activate([
            memoBodyTextView.topAnchor.constraint(equalTo: view.topAnchor),
            memoBodyTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            memoBodyTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            memoBodyTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapTextView(_:)))
        memoBodyTextView.addGestureRecognizer(tapGesture)
    }
    
    private func refreshUI() {
        loadViewIfNeeded()
        guard let memo = memo else {
            return
        }
        let title = memo.title
        let fontAttributeKey = NSAttributedString.Key(rawValue: kCTFontAttributeName as String)
        let fontSize = UIFont.preferredFont(forTextStyle: .title1)
        let content = NSMutableAttributedString(string: "\(memo.title)\n\n\(memo.body)")
        content.addAttribute(fontAttributeKey, value: fontSize, range: NSMakeRange(0, title.count))
        memoBodyTextView.attributedText = content
    }
}

//MARK: extension UITextViewDelegate
extension DetailViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.isEditable = false
        textView.dataDetectorTypes = [.link, .phoneNumber, .calendarEvent]
        textView.resignFirstResponder()
    }
    
    @objc private func tapTextView(_ gesture: UITapGestureRecognizer) {
        memoBodyTextView.isEditable = true
        memoBodyTextView.dataDetectorTypes = []
        memoBodyTextView.becomeFirstResponder()
    }
}

extension DetailViewController: MemoSelectionDelegate {
    func memoSelected(_ memo: Memo) {
        self.memo = memo
    }
}
