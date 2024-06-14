//
//  AllecordsFloatingButton.swift
//  Allecords
//
//  Created by Hoon on 5/22/24.
//

import UIKit

final class AllecordsFloatingButton: UIButton {
	override init(frame: CGRect) {
		super.init(frame: frame)
		setAttribute()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		layer.cornerRadius = frame.size.width / 2
		layer.masksToBounds = true
		
		layer.shadowColor = UIColor.background.cgColor
		layer.shadowOpacity = 0.3
		layer.shadowOffset = CGSize(width: 2, height: 2)
		layer.shadowRadius = 4
	}
	
	private func setAttribute() {
		backgroundColor = .primaryLight
		setImage(UIImage(systemName: "plus"), for: .normal)
		tintColor = .white
	}
}
