//
//  AllecordsNavigationItem.swift
//  Allecords
//
//  Created by Hoon on 4/5/24.
//

import UIKit

enum AllecordsNavigationItemType {
	case search
	case bell
}

extension AllecordsNavigationItemType {
	var image: UIImage? {
		switch self {
		case .search: return .init(systemName: "magnifyingglass")
		case .bell: return .init(systemName: "bell")
		}
	}
	
	var string: String? {
		switch self {
		case .search: return nil
		case .bell: return nil
		}
	}
}

final class AllecordsNavigationBarItem: UIButton {
	internal private(set) var type: AllecordsNavigationItemType
	
	init(type: AllecordsNavigationItemType) {
		self.type = type
		super.init(frame: .zero)
		setImage(type.image, for: .normal)
		imageView?.tintColor = .primary1
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

final class AllecordsNavigationBackButtonItem: UIButton {
	init(backButtonTitle: String?) {
		super.init(frame: .zero)
		let backButtonImage = UIImage.init(systemName: "chevron.backward")!
			.resizeImage(to: 24)?
			.withTintColor(UIColor.primary1)
		setImage(backButtonImage, for: .normal)
		
		let attributedTitle = NSAttributedString(
			string: backButtonTitle ?? "",
			attributes: [
				.font: UIFont.notoSansCJKkr(type: .medium, size: .medium) as Any,
				.foregroundColor: UIColor.primary1
			]
		)
		setAttributedTitle(attributedTitle, for: .normal)
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setBackButtonTitle(_ title: String) {
		setTitle(title, for: .normal)
	}
}
