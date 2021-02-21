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
    
    private var memoBodyTextView: MemoTextView = {
        let textView = MemoTextView()
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
        view.backgroundColor = .white
        setUpTextView()
        setUpNavigationBar()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setUpNavigationBar()
    }
    
    private func setUpNavigationBar() {
        if traitCollection.horizontalSizeClass == .regular &&
            UIDevice.current.orientation.isLandscape {
            navigationController?.navigationBar.isHidden = true
        }
        else {
            navigationController?.navigationBar.isHidden = false
        }
    }
    
    private func setUpTextView() {
        memoBodyTextView.delegate = self
        view.addSubview(memoBodyTextView)
        memoBodyTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            memoBodyTextView.topAnchor.constraint(equalTo: view.topAnchor),
            memoBodyTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            memoBodyTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            memoBodyTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func refreshUI() {
        loadViewIfNeeded()
        guard let memo = memo else {
            return
        }
        let title = memo.title
        let fontAttributeKey = NSAttributedString.Key(rawValue: kCTFontAttributeName as String)
        let fontSize = UIFont.preferredFont(forTextStyle: .title1)
        let content = NSMutableAttributedString(string: "\(memo.title)\n\n\(memo.body)\n010-1234-1234\nwww.naver.com\n2021.03.09\n")
        content.addAttribute(fontAttributeKey, value: fontSize, range: NSMakeRange(0, title.count))
        memoBodyTextView.attributedText = content
    }
}

//MARK: - extension UITextViewDelegate
extension DetailViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.isEditable = false
        textView.dataDetectorTypes = [.link, .phoneNumber, .calendarEvent]
    }
}

extension DetailViewController: MemoSelectionDelegate {
    func memoSelected(_ memo: Memo) {
        self.memo = memo
    }
}
