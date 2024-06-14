//
//  AllecordsTextField.swift
//  Allecords
//
//  Created by Hoon on 5/22/24.
//

import UIKit

final class AllecordsTextField: UITextField {
	private let bottomLine = UIView()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setViewAttributes()
		setViewHierachies()
		setViewConstraints()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func textRect(forBounds bounds: CGRect) -> CGRect {
		let defaultRect = super.textRect(forBounds: bounds)
		return CGRect(
			x: defaultRect.origin.x,
			y: defaultRect.origin.y,
			width: defaultRect.size.width,
			height: defaultRect.size.height - (Constant.textBottomPadding + Constant.bottomLine)
		)
	}
	
	override func editingRect(forBounds bounds: CGRect) -> CGRect {
		let defaultRect = super.editingRect(forBounds: bounds)
		return CGRect(
			x: defaultRect.origin.x,
			y: defaultRect.origin.y,
			width: defaultRect.size.width,
			height: defaultRect.size.height - (Constant.textBottomPadding + Constant.bottomLine)
		)
	}
	
	func setPlaceHolderText(_ text: String) {
		placeholder = text
	}
}

// MARK: - SetUp
private extension AllecordsTextField {
	enum Constant {
		static let bottomLine = 1.5
		static let textBottomPadding = 4.0
	}
	
	func setViewAttributes() {
		bottomLine.backgroundColor = .gray4
		font = .notoSansCJKkr(type: .medium, size: .large)
		autocorrectionType = .no
		spellCheckingType = .no
		autocapitalizationType = .none
		clearButtonMode = .always
	}
	
	func setViewHierachies() {
		addSubview(bottomLine)
		bottomLine.translatesAutoresizingMaskIntoConstraints = false
	}
	
	func setViewConstraints() {
		NSLayoutConstraint.activate([
			bottomLine.leadingAnchor.constraint(equalTo: leadingAnchor),
			bottomLine.trailingAnchor.constraint(equalTo: trailingAnchor),
			bottomLine.bottomAnchor.constraint(equalTo: bottomAnchor),
			bottomLine.heightAnchor.constraint(equalToConstant: Constant.bottomLine)
		])
	}
}
