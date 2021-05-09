//
//  MemoTableViewCell.swift
//  CloudNotes
//
//  Created by Yeon on 2021/02/16.
//

import UIKit

final class MemoTableViewCell: UITableViewCell {
    //MARK: Properties
    private var memoTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = DarkModeColorManager.dynamicColor
        label.font = .preferredFont(forTextStyle: .title3)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    private var memoDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.systemGray
        label.font = .preferredFont(forTextStyle: .body)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    private var memoModifiedDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = DarkModeColorManager.dynamicColor
        label.font = .preferredFont(forTextStyle: .body)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: SetUpMemoTableViewCell
    private func setUpView() {
        contentView.addSubview(memoTitleLabel)
        contentView.addSubview(memoDescriptionLabel)
        contentView.addSubview(memoModifiedDateLabel)
        
        NSLayoutConstraint.activate([
            memoTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            memoTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            memoTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            
            memoModifiedDateLabel.topAnchor.constraint(equalTo: memoTitleLabel.bottomAnchor, constant: 5),
            memoModifiedDateLabel.leadingAnchor.constraint(equalTo: memoTitleLabel.leadingAnchor),
            memoModifiedDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            memoDescriptionLabel.leadingAnchor.constraint(equalTo: memoModifiedDateLabel.trailingAnchor, constant: 30),
            memoDescriptionLabel.topAnchor.constraint(equalTo: memoModifiedDateLabel.topAnchor),
            memoDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            memoDescriptionLabel.bottomAnchor.constraint(equalTo: memoModifiedDateLabel.bottomAnchor)
        ])
    }
    
    func setUpMemoCell(_ memo: Memo) {
        let (title, body) = splitContent(memo)
        memoTitleLabel.text = title
        memoDescriptionLabel.text = body
        memoModifiedDateLabel.text = memo.registerDate.stringFromDate
    }
    
    private func splitContent(_ memo: Memo) -> (String, String) {
        let defaultTitle = "새로운 메모"
        let defaultBody = "추가 텍스트 없음"
        
        guard let content = memo.content else {
            return (defaultTitle, defaultBody)
        }
        
        var lines = content.split(separator: "\n")
        guard let title = lines.first else {
            return (defaultTitle, defaultBody)
        }
        lines.removeFirst()

        guard let body = lines.first else {
            return (String(title), defaultBody)
        }
        return (String(title), String(body))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        memoTitleLabel.text = nil
        memoDescriptionLabel.text = nil
        memoModifiedDateLabel.text = nil
    }
}
