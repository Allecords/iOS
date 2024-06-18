//
//  ChatMyTableViewCell.swift
//  Allecords
//
//  Created by Hoon on 6/18/24.
//

import UIKit

final class ChatMyTableViewCell: UITableViewCell {
	static let identifier = "ChatMyTableViewCell"
	
	private let messageBox: UITextView = .init()
	private let date: UILabel = .init()
	
	override init(
		style: UITableViewCell.CellStyle,
		reuseIdentifier: String?
	) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupViews()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func configure(text: String, time: String) {
		self.messageBox.text = text
		self.date.text = time
	}
}

extension ChatMyTableViewCell {
	func setTextView() {
		messageBox.isScrollEnabled = false
		messageBox.isEditable = false
		messageBox.backgroundColor = .gray5
		messageBox.textContainerInset = .init(top: 5, left: 5, bottom: 5, right: 5)
		messageBox.layer.cornerRadius = 10
		messageBox.font = .notoSansCJKkr(type: .medium, size: .small)
		messageBox.sizeToFit()
	}
	
	func setDate() {
		date.numberOfLines = 0
		date.backgroundColor = .clear
		date.textColor = .black
		date.font = .notoSansCJKkr(type: .medium, size: .tiny)
	}
	
	func setupViews() {
		setTextView()
		setDate()
		
		selectionStyle = .none
		
		contentView.addSubview(messageBox)
		contentView.addSubview(date)
		
		messageBox.translatesAutoresizingMaskIntoConstraints = false
		date.translatesAutoresizingMaskIntoConstraints = false
		
		// messageBox constraints
		NSLayoutConstraint.activate([
			messageBox.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
			messageBox.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
			messageBox.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
			messageBox.heightAnchor.constraint(greaterThanOrEqualToConstant: 45),
			messageBox.widthAnchor.constraint(lessThanOrEqualToConstant: 255),
			messageBox.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
		])
		
		// date constraints
		NSLayoutConstraint.activate([
			date.trailingAnchor.constraint(equalTo: messageBox.leadingAnchor, constant: -5),
			date.bottomAnchor.constraint(equalTo: messageBox.bottomAnchor)
		])
	}
}
