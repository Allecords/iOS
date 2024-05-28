//
//  AllecordsConfirmButton.swift
//  Allecords
//
//  Created by Hoon on 5/28/24.
//

import UIKit

final class AllecordsConfirmButton: UIButton {
	override init(frame: CGRect = .zero) {
		super.init(frame: frame)
		setButton()
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setButton() {
		setTitle("", for: .normal)
		titleLabel?.font = .notoSansCJKkr(type: .medium, size: .large)
		backgroundColor = .primaryDark
	}
	
	func configure(_ title: String) {
		setTitle(title, for: .normal)
	}
}
