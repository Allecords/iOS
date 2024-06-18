//
//  AllecordsBottomView.swift
//  Allecords
//
//  Created by Hoon on 6/14/24.
//

import UIKit

protocol AllecordsBottomButtonDelegate: AnyObject {
	func didTapConfirmButton()
}

final class AllecordsBottomView: UIView {
	private let confirmButton: AllecordsConfirmButton = .init()
	weak var delegate: AllecordsBottomButtonDelegate?
	
	override init(frame: CGRect = .zero) {
		super.init(frame: frame)
		setViewAttribute()
		setViewHierachies()
		setViewConstraints()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

private extension AllecordsBottomView {
	enum Constant {
		static let tenPadding: CGFloat = 10
		static let basePadding: CGFloat = 20
	}
	
	func setViewAttribute() {
		backgroundColor = .background
		confirmButton.configure("채팅하기")
		confirmButton.addTarget(self, action: #selector(confirmButtonDidTapped), for: .touchUpInside)
	}
	
	func setViewHierachies() {
		addSubview(confirmButton)
		confirmButton.translatesAutoresizingMaskIntoConstraints = false
	}
	
	func setViewConstraints() {
		NSLayoutConstraint.activate([
			confirmButton.centerYAnchor.constraint(equalTo: centerYAnchor),
			confirmButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constant.basePadding),
			confirmButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constant.basePadding)
		])
	}
	
	@objc func confirmButtonDidTapped() {
		delegate?.didTapConfirmButton()
	}
}
